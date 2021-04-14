import 'dart:convert';

import 'dart:io' as io;
// import 'dart:html';
import 'package:Dissertation/utilities/index.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

// import 'package:flutter/services.dart' show rootServices;
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
// import 'dart:async';
import 'package:async/async.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  int currentState = 0;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // File? _image;
  String? image;
  final picker = ImagePicker();
  int appState = 0;
  bool hover = false;
  Map result = {};
  String inputImage = '';
  String heatmap = '';
  Future getImage() async {
    setState(() {});
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    var pickedFileBytes = await pickedFile?.readAsBytes();
    image = base64Encode(pickedFileBytes!);
    setState(() {});
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  Future<List<Map>> getGallery(name, noFiles) async {
    List<Map> gallery = [];

    for (int i = 1; i <= noFiles; i++) {
      String path = name + '/' + i.toString() + '/';

      var jsonData = await parseJsonFromAssets(path + 'result.json');
      gallery.add({
        'Input': path + 'input.jpg',
        'Output': path + 'heatmap.jpg',
        'Diagnosis': jsonData['Diagnosis']
      });
    }
    return gallery;
  }

  Future<Map> getPrediction(String url, String image) async {
    url =
        'http://127.0.0.1:5000/' + url + '?Image=' + Uri.encodeComponent(image);
    http.Response response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //write or call your logic
      //code will run when widget rendering complete
    });
  }

  int currentIndex = 0;
  Widget build(BuildContext context) {
    final ScrollController _scrollController =
        ScrollController(initialScrollOffset: 50.0);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(spreadRadius: 0.25),
            ],
          ),
          margin: EdgeInsets.all(40),
          padding: EdgeInsets.all(20),
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'COVID-19 & Pneumonia Detection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Center(
                //   child: Text(
                //     'Dissertation 2021 - Alister George Luiz (agl2)',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       fontSize: 28,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Disclaimer',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'This website provides an AI model for Covid-19 detection and Pneumonia from X-Ray scans.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                  SizedBox(height: screenHeight(context) * 0.03),

                Center(
                  child: Text(
                    'You must not use this in anyway as a diagnosis tool or for any other medical purposes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight(context) * 0.03),

                Center(
                  child: Text(
                    'This website was developed as part of Dissertation by Alister George Luiz (agl2) in the year 2021',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight(context) * 0.03),

                Center(
                  child: Text(
                    'The website is part of a research submission and the model we propose has not been clinically tested. We are not responsible for any usage of the results displayed by the website.\nPlease do note that the website is only a proof of concept and is running on very limited resources.\n\nPlease contact Dr Hani Ragab Hassen if you have questions or suggestions.\nFor more information on evaluating AI models for Covid-19 detection, please read:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight(context) * 0.03),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        launch('https://arxiv.org/abs/2004.12823');
                      },
                      child: Center(
                        child: Text(
                          'https://arxiv.org/abs/2004.12823',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    Text(
                      'and',
                      // style: TextStyle(color: Colors.blue),
                    ),
                    InkWell(
                      onTap: () {
                        launch('https://arxiv.org/abs/2004.05405');
                      },
                      child: Center(
                        child: Text(
                          'https://arxiv.org/abs/2004.05405',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                // Center(
                //   child: RichText(
                //     text: TextSpan(
                //       children: [
                //         TextSpan(
                //           text: 'https://arxiv.org/abs/2004.12823',
                //           style: TextStyle(color: Colors.blue),
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               launch('https://arxiv.org/abs/2004.12823');
                //             },
                //         ),
                //         TextSpan(
                //           text: ' and ',
                //         ),
                //         TextSpan(
                //           text: 'https://arxiv.org/abs/2004.05405',
                //           style: TextStyle(color: Colors.blue),
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               launch('https://arxiv.org/abs/2004.05405');
                //             },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                SizedBox(height: 15),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 450,
                //   ),
                //   child: TextButton(
                //     onPressed: () async {
                //       setState(() {});
                //     },
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(Icons.android_sharp),
                //         SizedBox(
                //           width: 10,
                //         ),
                //         Text(
                //           'Android App',
                //         ),
                //       ],
                //     ),
                //     style: TextButton.styleFrom(
                //         fixedSize: Size(screenWidth(context) * 0.05,
                //             screenHeight(context) * 0.07),
                //         primary: Colors.white,
                //         backgroundColor: Colors.green,
                //         textStyle: TextStyle(
                //           fontSize: 20,
                //         )),
                //   ),
                // ),
              
                SizedBox(height: 15),
       
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: TabBar(
                    onTap: (int index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    // controller: _tabController,
                    unselectedLabelColor: Colors.blue,
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(color: Colors.blue),
                    tabs: [
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.blue, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "X-RAY",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 1),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "CT",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    setState(() {});
                    getImage();
                    appState = 0;
                    image = null;
                    setState(() {});
                  },
                  onHover: (b) {
                    setState(() {
                      hover = b;
                    });
                  },
                  child: Container(
                    height: 150,
                    margin: EdgeInsets.symmetric(
                      horizontal: 100,
                    ),
                    decoration: BoxDecoration(
                      color: hover == true ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Click to upload your Scan!',
                          style: TextStyle(
                            fontSize: 24,
                            color: hover == true ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                (image != null && appState == 0)
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.memory(
                                base64.decode(image!),
                                height: screenHeight(context) * 0.4,
                                width: screenWidth(context) * 0.30,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: screenWidth(context) * 0.02,
                              ),
                              Container(
                                width: screenWidth(context) * 0.35,
                                child: Column(
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Would you like to proceed with diagnosis?',
                                        style: TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: screenWidth(context) * 0.6,
                                      height: screenHeight(context) * 0.15,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              setState(() {});
                                              appState = 2;
                                              if (currentIndex == 0) {
                                                result = await getPrediction(
                                                    'xray', image!);
                                                inputImage =
                                                    'http://127.0.0.1:5000/static/' +
                                                        result['UUID'] +
                                                        '/input.jpg';
                                                heatmap =
                                                    'http://127.0.0.1:5000/static/' +
                                                        result['UUID'] +
                                                        '/heatmap.jpg';
                                              } else {
                                                result = await getPrediction(
                                                    'ct', image!);
                                                inputImage =
                                                    'http://127.0.0.1:5000/static/' +
                                                        result['UUID'] +
                                                        '/input.jpg';
                                                heatmap =
                                                    'http://127.0.0.1:5000/static/' +
                                                        result['UUID'] +
                                                        '/heatmap.jpg';
                                              }
                                              setState(() {});
                                              if (result != {}) {
                                                print('JSON RESULT' +
                                                    result.toString());
                                                appState = 1;
                                              }
                                              setState(() {});
                                            },
                                            child: Text(
                                              'Yes',
                                            ),
                                            style: TextButton.styleFrom(
                                                fixedSize: Size(
                                                    screenWidth(context) * 0.15,
                                                    screenHeight(context) *
                                                        0.07),
                                                primary: Colors.white,
                                                backgroundColor: Colors.green,
                                                textStyle: TextStyle(
                                                  fontSize: 24,
                                                )),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                image = null;
                                              });
                                            },
                                            child: Text(
                                              'No',
                                            ),
                                            style: TextButton.styleFrom(
                                                fixedSize: Size(
                                                    screenWidth(context) * 0.15,
                                                    screenHeight(context) *
                                                        0.07),
                                                primary: Colors.white,
                                                backgroundColor: Colors.red,
                                                textStyle: TextStyle(
                                                  fontSize: 24,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                        ],
                      )
                    : (image != null && appState == 1 && result != {})
                        ? Column(
                            children: [
                              Center(
                                child: Text(
                                  'Diagnosis Result: ' + result['Diagnosis'],
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                              displayHeatMap(context, inputImage, heatmap, 1),
                              SizedBox(height: 40),
                            ],
                          )
                        : (image != null && appState == 2)
                            ? Column(
                                children: [
                                  Text(
                                    'Diagnosing...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Column(
                                        children: [
                                          CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: screenHeight(context) * 0.05),
                                ],
                              )
                            : SizedBox(height: screenHeight(context) * 0.05),
                Center(
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder<List<Map>>(
                    future: currentIndex == 0
                        ? getGallery('xray', 24)
                        : getGallery('ct', 5),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                        );
                      }
                      List<Map> data = snapshot.data ?? [];
                      for (int i = 0; i < data.length; i++) {
                        if (data[i]['Diagnosis'] == 'NORMAL') {
                          data.removeAt(i);
                        }
                      }
                      return CarouselSlider(
                        options: CarouselOptions(
                          height: screenHeight(context) * 0.5,
                          autoPlay: true,
                          viewportFraction: 1,
                        ),
                        items: data.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        'Diagnosis Result: ' + i['Diagnosis'],
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    displayHeatMap(
                                        context, i['Input'], i['Output'], 2),
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container displayHeatMap(context, image1, image2, type) {
    return Container(
      height: screenHeight(context) * 0.37,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: screenHeight(context) * 0.35,
            width: screenWidth(context) * 0.28,
            color: Colors.blue,
            child: (type == 1)
                ? Image.network(
                    image1,
                    height: screenHeight(context) * 0.32,
                    width: screenWidth(context) * 0.25,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    image1,
                    height: screenHeight(context) * 0.32,
                    width: screenWidth(context) * 0.25,
                    fit: BoxFit.fill,
                  ),
          ),
          Container(
            height: screenHeight(context) * 0.35,
            width: screenWidth(context) * 0.28,
            color: Colors.blue,
            child: (type == 1)
                ? Image.network(
                    image2,
                    height: screenHeight(context) * 0.32,
                    width: screenWidth(context) * 0.25,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    image2,
                    height: screenHeight(context) * 0.32,
                    width: screenWidth(context) * 0.25,
                    fit: BoxFit.fill,
                  ),
          ),
        ],
      ),
    );
  }
}
