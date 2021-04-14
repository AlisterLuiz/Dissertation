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

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
// import 'dart:async';
import 'package:async/async.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePagePortrait extends StatefulWidget {
  MyHomePagePortrait({Key? key, required this.title}) : super(key: key);
  final String title;

  int currentState = 0;
  @override
  _MyHomePagePortraitState createState() => _MyHomePagePortraitState();
}

class _MyHomePagePortraitState extends State<MyHomePagePortrait>
    with TickerProviderStateMixin {
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
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth(context) * 0.05,
            vertical: screenHeight(context) * 0.07,
          ),
          padding: EdgeInsets.all(20),
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
              // SizedBox(
              //   height: screenHeight(context) * 0.02,
              // ),
              // Center(
              //   child: FittedBox(
              //     fit: BoxFit.scaleDown,
              //     child: Text(
              //       'Dissertation 2021 - Alister George Luiz (agl2)',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 28,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              Center(
                child: Text(
                  'This application provides an AI model for Covid-19 detection and Pneumonia from X-Ray scans.',
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
                  'The application is part of a research submission and the model we propose has not been clinically tested. We are not responsible for any usage of the results displayed by the application.\nPlease do note that the application is only a proof of concept and is running on very limited resources.\n\nPlease contact Dr Hani Ragab Hassen if you have questions or suggestions.\nFor more information on evaluating AI models for Covid-19 detection, please read:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: screenHeight(context) * 0.03),
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
              // SizedBox(height: 15),
              // TextButton(
              //   onPressed: () async {
              //     setState(() {});
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(Icons.android_sharp),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Text(
              //         'Android App',
              //       ),
              //     ],
              //   ),
              //   style: TextButton.styleFrom(
              //       fixedSize: Size(screenWidth(context) * 0.05,
              //           screenHeight(context) * 0.07),
              //       primary: Colors.white,
              //       backgroundColor: Colors.green,
              //       textStyle: TextStyle(
              //         fontSize: 20,
              //       )),
              // ),
          
              SizedBox(
                height: screenHeight(context) * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
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
              SizedBox(
                height: screenHeight(context) * 0.05,
              ),
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
                  height: screenHeight(context) * 0.15,
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.1,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
              ),
              SizedBox(height: screenHeight(context) * 0.05),
              (image != null && appState == 0)
                  ? Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.memory(
                              base64.decode(image!),
                              height: screenHeight(context) * 0.4,
                              width: screenWidth(context) * 0.4,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.04,
                            ),
                            Column(
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
                                SizedBox(
                                  height: screenHeight(context) * 0.04,
                                ),
                                Container(
                                  width: screenWidth(context) * 0.8,
                                  height: screenHeight(context) * 0.1,
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
                                              screenWidth(context) * 0.35,
                                              screenHeight(context) * 0.07,
                                            ),
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
                                              screenWidth(context) * 0.35,
                                              screenHeight(context) * 0.07,
                                            ),
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
                          ],
                        ),
                        SizedBox(height: screenHeight(context) * 0.05),
                      ],
                    )
                  : (image != null && appState == 1 && result != {})
                      ? Column(
                          children: [
                            Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Diagnosis Result: ' + result['Diagnosis'],
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight(context) * 0.08),
                            displayHeatMap(context, inputImage, heatmap, 1),
                            SizedBox(height: screenHeight(context) * 0.08),
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
                                SizedBox(height: screenHeight(context) * 0.03),
                              ],
                            )
                          : SizedBox(height: screenHeight(context) * 0.03),
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight(context) * 0.03,
              ),
              FutureBuilder<List<Map>>(
                  future: currentIndex == 0
                      ? getGallery('xray', 24)
                      : getGallery('ct', 5),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        children: [
                          Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    }
                    List<Map> data = snapshot.data ?? [];
                    for (int i = 0; i < data.length; i++) {
                      if (data[i]['Diagnosis'] == 'NORMAL') {
                        data.removeAt(i);
                      }
                    }
                    print('SNAPSHOT' + data.toString());
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: screenHeight(context) * 0.9,
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
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Diagnosis Result: ' + i['Diagnosis'],
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                        ),
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
    );
  }

  Container displayHeatMap(context, image1, image2, type) {
    return Container(
      // height: screenHeight(context) * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            // height: screenHeight(context) * 0.45,
            // width: screenWidth(context) * 0.45,
            color: Colors.blue,
            child: (type == 1)
                ? Image.network(
                    image1,
                    height: screenHeight(context) * 0.35,
                    width: screenWidth(context) * 0.35,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    image1,
                    height: screenHeight(context) * 0.35,
                    width: screenWidth(context) * 0.35,
                    fit: BoxFit.fill,
                  ),
          ),
          SizedBox(height: screenHeight(context) * 0.05),
          Container(
            // height: screenHeight(context) * 0.45,
            // width: screenWidth(context) * 0.45,
            color: Colors.blue,
            child: (type == 1)
                ? Image.network(
                    image2,
                    height: screenHeight(context) * 0.35,
                    width: screenWidth(context) * 0.35,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    image2,
                    height: screenHeight(context) * 0.35,
                    width: screenWidth(context) * 0.35,
                    fit: BoxFit.fill,
                  ),
          ),
        ],
      ),
    );
  }
}
