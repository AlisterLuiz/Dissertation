# Importing Required Python Libraries
import os
from collections import Counter
import pickle
import glob
import h5py
import shutil
import random
import json
import uuid
import base64
import io
from io import StringIO

# Importing Required Python Libraries
import numpy as np
import cv2    
import pandas as pd  
from PIL import Image

# Importing Visualization Libraries
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import matplotlib.image as mpimg

# Importing Scikit-Learn's Libraries
from sklearn.utils import class_weight, shuffle
from sklearn.metrics import classification_report, confusion_matrix, roc_auc_score, auc
from sklearn.model_selection import StratifiedKFold, KFold, cross_val_score, cross_val_predict
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
# from skimage import measure, morphology
# from skimage.transform import resize
from sklearn.cluster import KMeans

# Importing Tensorflow and Keras Libraries
import tensorflow as tf 
from tensorflow.keras import Model
from tensorflow.keras.utils import plot_model
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import ReduceLROnPlateau , ModelCheckpoint, Callback
from tensorflow.keras.models import load_model 
from tensorflow.keras.utils import to_categorical
from tensorflow.keras import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Softmax, Activation, Dense, Dropout
from tensorflow import keras
from tensorflow.keras.preprocessing.image import ImageDataGenerator, array_to_img, img_to_array, load_img

def make_gradcam_heatmap(img_array, model, last_conv_layer_name, classifier_layer_names):
    """
    Defines the Grad-CAM saliency map technique.
    Identifies the pixels which contribute the most to the classification.
    Code excerpt taken from:
    https://keras.io/examples/vision/grad_cam/
    """
    # First, we create a model that maps the input image to the activations
    # of the last conv layer
    last_conv_layer = model.get_layer(last_conv_layer_name)
    last_conv_layer_model = keras.Model(model.inputs, last_conv_layer.output)

    # Second, we create a model that maps the activations of the last conv
    # layer to the final class predictions
    classifier_input = keras.Input(shape=last_conv_layer.output.shape[1:])
    x = classifier_input
    for layer_name in classifier_layer_names:
        x = model.get_layer(layer_name)(x)
    classifier_model = keras.Model(classifier_input, x)

    # Then, we compute the gradient of the top predicted class for our input image
    # with respect to the activations of the last conv layer
    with tf.GradientTape() as tape:
        # Compute activations of the last conv layer and make the tape watch it
        last_conv_layer_output = last_conv_layer_model(img_array)
        tape.watch(last_conv_layer_output)
        # Compute class predictions
        preds = classifier_model(last_conv_layer_output)
        top_pred_index = tf.argmax(preds[0])
        top_class_channel = preds[:, top_pred_index]

    # This is the gradient of the top predicted class with regard to
    # the output feature map of the last conv layer
    grads = tape.gradient(top_class_channel, last_conv_layer_output)

    # This is a vector where each entry is the mean intensity of the gradient
    # over a specific feature map channel
    pooled_grads = tf.reduce_mean(grads, axis=(0, 1, 2))

    # We multiply each channel in the feature map array
    # by "how important this channel is" with regard to the top predicted class
    last_conv_layer_output = last_conv_layer_output.numpy()[0]
    pooled_grads = pooled_grads.numpy()
    for i in range(pooled_grads.shape[-1]):
        last_conv_layer_output[:, :, i] *= pooled_grads[i]

    # The channel-wise mean of the resulting feature map
    # is our heatmap of class activation
    heatmap = np.mean(last_conv_layer_output, axis=-1)

    # For visualization purpose, we will also normalize the heatmap between 0 & 1
    heatmap = np.maximum(heatmap, 0) / np.max(heatmap)
    # Returns the heatmap and the index of the most probable class
    return heatmap, top_pred_index.numpy()

def superimposed_img(image, heatmap, imageSize):
    """
    Superimposes the Grad-CAM heatmap with the original 
    image.
    Code excerpt taken from:
    https://keras.io/examples/vision/grad_cam/
    """
    # We rescale heatmap to a range 0-255
    heatmap = np.uint8(255 * heatmap)

    # We use jet colormap to colorize heatmap
    jet = cm.get_cmap("jet")

    # We use RGB values of the colormap
    jet_colors = jet(np.arange(256))[:, :3]
    jet_heatmap = jet_colors[heatmap]

    # We create an image with RGB colorized heatmap
    jet_heatmap = keras.preprocessing.image.array_to_img(jet_heatmap)
    jet_heatmap = jet_heatmap.resize((imageSize, imageSize))
    jet_heatmap = keras.preprocessing.image.img_to_array(jet_heatmap)

    # Superimpose the heatmap on original image
    superimposed_img = jet_heatmap * 0.4 + image
    superimposed_img = keras.preprocessing.image.array_to_img(superimposed_img)
    return superimposed_img

# Load best performing models
reconstructedDenseNet = tf.keras.models.load_model('./static/models/DenseNet4.h5')
reconstructedResNet = tf.keras.models.load_model('./static/models/ResNet9.h5')
reconstructedVGG = tf.keras.models.load_model('./static/models/VGG8.h5')

# Initialize Labels and Layer Names
labels = ["COVID19", "NORMAL", "PNEUMONIA"]
models = [reconstructedDenseNet, reconstructedResNet, reconstructedVGG]
lastConvLayerNames = {"DenseNet": "conv5_block16_concat", "ResNet": "conv5_block3_out", "VGG": "block5_conv3"}
classifierLayerNames = { 
    "DenseNet": [
                  "bn",
                  "relu",
                  "global_average_pooling2d_4",
                  "dense_8",
                  "dense_9",
    ],
    "ResNet": [
               "global_average_pooling2d_11",
               "dense_22",
               "dense_23",
    ],
    "VGG": [
            "block5_pool",
            "global_average_pooling2d_28",
            "dense_56",
            "dense_57",
    ]
}


def makeDecisionXRay(base64Image):
  """
    Function retrieves the heatmap and diagnosis result for a given test image 
  """
  uid = str(uuid.uuid4())
  outputPath = './static/' + uid
  os.makedirs(outputPath, exist_ok=True)
  b64 = base64.b64decode(base64Image)
  bufferImage = np.frombuffer(b64, dtype=np.uint8)
  img = cv2.imdecode(bufferImage, flags=cv2.IMREAD_COLOR)
  testImage = cv2.resize(img, (224, 224), interpolation=cv2.INTER_NEAREST)
  testImage = np.expand_dims(testImage, axis=0)
  heatmaps = []
  for i, model in enumerate(models):
    convLayer = lastConvLayerNames[list(lastConvLayerNames.keys())[i]]
    classifierLayerName = classifierLayerNames[list(classifierLayerNames.keys())[i]]
    heatmap, topIndex = make_gradcam_heatmap(testImage, model, convLayer, classifierLayerName)
    sImg = superimposed_img(testImage[0], heatmap, 224)
    heatmaps.append(sImg)
  
  # Create a numpy array of floats to store the average (assume RGB images)
  finalHeatmap = np.zeros((224, 224,3), np.float)
  for im in heatmaps:
    imageArray = np.array(im, dtype = np.float)
    # N = 3, because of 3 separate images to be combined
    finalHeatmap = finalHeatmap + imageArray/3
  
  # Round values in array and cast as 8-bit integer
  finalHeatmap = np.array(np.round(finalHeatmap), dtype = np.uint8)
  outputImage = Image.fromarray(finalHeatmap, mode="RGB")
  
  outputImage.save(os.path.join(outputPath, 'heatmap.jpg'))

  with open(os.path.join(outputPath, 'input.jpg'),"wb") as f:
    f.write(base64.b64decode(base64Image))

  reconstructedEnsembleXRay = tf.keras.models.load_model('./static/models/EnsembleXRay10.h5')
  predictionIndex = np.argmax(reconstructedEnsembleXRay.predict(testImage))

  # Store the result in a map 
  jsonResult = {}
  jsonResult['UUID'] = uid
  jsonResult['Diagnosis'] = labels[predictionIndex]
  jsonResult['Accuracy'] = '98%'
  return jsonResult

