from flask import Flask, request, jsonify, send_from_directory
from xrayScript import makeDecisionXRay
from ctScript import makeDecisionCT
import os
import base64
import uuid
from flask_cors import CORS, cross_origin


app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

@app.route('/')
def helloWorld():
    return 'Hello World!'

@app.route('/xray', methods=['GET'])
def predictXRay():
    d = {}
    d['Image'] = str(request.args['Image'])
    prediction = makeDecisionXRay(d['Image'])
    return jsonify(prediction)


@app.route('/ct', methods=['GET'])
def predictCT():
    d = {}
    d['Image'] = str(request.args['Image'])
    prediction = makeDecisionCT(d['Image'])
    return jsonify(prediction)


if __name__ == '__main__':
    app.run()
