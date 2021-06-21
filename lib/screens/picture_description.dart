import 'dart:developer';
import 'dart:io';
import 'package:camera_scan/extractdatanotifier.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imagePackage;
import 'package:provider/provider.dart';

class PictureDescription extends StatefulWidget {
  final String imagePath;
  final InputImage inputImage;
  final int width;
  final int height;
  final String imageCroppedPath;
  final int startingPointX;
  final int startingPointY;
  final String imageName;
  const PictureDescription(
      {@required this.imagePath,
      @required this.inputImage,
      this.width,
      this.height,
      this.imageCroppedPath,
      this.startingPointX,
      this.startingPointY,
      this.imageName});
  @override
  _PictureDescriptionState createState() => _PictureDescriptionState();
}

class _PictureDescriptionState extends State<PictureDescription> {
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  String dataProcessed;
  RecognisedText recognisedText;
  String pathToCroppedImage = "";
  int counter = 0;
  String nric = "";
  String name = "";
  String address = "";
  bool isWarganegara = false;
  String gender = "";
  String religion = "";
  TextEditingController nricController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController warganegaraController =
      TextEditingController(text: 'TIDAK');
  // Future<ResultData> initProcessImage;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final extractDataNotifier = context.watch<ExctractData>();
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: FutureBuilder<ResultData>(
                  future: processImage(widget.inputImage, extractDataNotifier),
                  builder: (context, snapshot) {
                    log('Snapshot has data? ${snapshot.hasData}');
                    if (snapshot.hasData) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Results',
                                  style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: widget.width.toDouble(),
                              height: widget.height.toDouble(),
                              decoration: BoxDecoration(
                                  color: Color(0xffFFB0B0),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      alignment: FractionalOffset.center,
                                      image: Image.file(File(widget.imagePath))
                                          .image)),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            //Text(snapshot.data ?? 'No data'),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'NRIC',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                nric,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              name,
                              style: TextStyle(fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Address',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              address,
                              style: TextStyle(fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Gender',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              gender,
                              style: TextStyle(fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Religion',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              religion,
                              style: TextStyle(fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Warganegara',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              isWarganegara ? 'Ya' : 'Tidak',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            // Container(
                            //   height: 300,
                            //   width: 300,
                            //   decoration: BoxDecoration(
                            //       color: Color(0xffFFB0B0),
                            //       image: DecorationImage(
                            //           fit: BoxFit.contain,
                            //           image: Image.file(
                            //             File(pathToCroppedImage),
                            //             errorBuilder:
                            //                 (context, object, stacktrace) {
                            //               return Text('No image cropped');
                            //             },
                            //           ).image)),
                            // ),
                            // ElevatedButton(
                            //     onPressed: () {
                            //       croppingImage(
                            //           filePath: widget.imagePath,
                            //           widthOfImage: widget.width,
                            //           heightOfImage: widget.height,
                            //           startingPointX: widget.startingPointX,
                            //           startingPointY: widget.startingPointY,
                            //           imageName: widget.imageName);
                            //     },
                            //     child: Text('Crop Image'))
                            // Image.file(

                            //   File(widget.imageCroppedPath),
                            //   errorBuilder: (context, object, stacktrace) {
                            //     return Text('No image');
                            //   },
                            // )
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }))),
    );
  }

  Future<ResultData> extractData(
      RecognisedText recognisedText, ExctractData exctractDataNotifier) async {
    try {
      //exctractDataNotifier.setState(ViewState.BUSY);
      int nricIndex = 0;
      int nameIndex = 0;
      var resultData = ResultData();
      for (int i = 0; i < recognisedText.blocks.length; i++) {
        print('Text of $i :  ${recognisedText.blocks[i].text} ');
        print('LENGTH OF THE FUCKING LIST : ${recognisedText.blocks.length}');
        if (recognisedText.blocks[i].text.contains('-')) {
          nric = recognisedText.blocks[i].text;
          resultData.nric = nric;
          nricIndex = i + 1;
        }

        if (i == nricIndex) {
          name = recognisedText.blocks[i].text;
          resultData.name = name;
          nameIndex = i + 1;
        }

        if (i == nameIndex) {
          address = recognisedText.blocks[i].text;
          resultData.address = address;
        }

        if (recognisedText.blocks[i].text.contains('WARGANEGARA')) {
          isWarganegara = true;
          resultData.warganegara = isWarganegara;
        } else {
          print(
              'Text sepatutnya warganegara: ${recognisedText.blocks[i].text}');
        }

        if (i == recognisedText.blocks.length - 1) {
          if (recognisedText.blocks[i].text.contains('LELAKI')) {
            int indexOfFirstLetter =
                recognisedText.blocks[i].text.indexOf('LELAKI');
            gender =
                recognisedText.blocks[i].text.substring(indexOfFirstLetter);
            resultData.gender = gender;
          }
          if (recognisedText.blocks[i].text.contains('PEREMPUAN')) {
            int indexOfFirstLetter =
                recognisedText.blocks[i].text.indexOf('PEREMPUAN');
            gender =
                recognisedText.blocks[i].text.substring(indexOfFirstLetter);
            resultData.gender = gender;
          }
        }

        // if (recognisedText.blocks[i].text.contains(RegExp(r"^[A-Z]*$"))) {
        //   name = recognisedText.blocks[i].text;
        // }
      }
      //exctractDataNotifier.setState(ViewState.IDLE);
      return resultData;
    } catch (e) {
      log("THE FUCKING ERROR :${e.toString()}");
    }
  }

  Future<ResultData> processImage(
      InputImage inputImage, ExctractData extractDataNotifier) async {
    final recognisedText = await textDetector.processImage(inputImage);
    print('The recognisedText :${recognisedText.text}');
    return await extractData(recognisedText, extractDataNotifier);
  }

  void croppingImage(
      {String filePath,
      int widthOfImage,
      int heightOfImage,
      int startingPointX,
      int startingPointY,
      String imageName}) {
    var pathToFileCache = '/data/user/0/com.example.camera_scan/cache';
    final fileOfImage = File(filePath);
    var decodedImage = imagePackage.decodeImage(fileOfImage.readAsBytesSync());
    final croppedImage = imagePackage.copyCrop(
      decodedImage,
      startingPointY * 5,
      startingPointX * 6,
      heightOfImage * 6,
      widthOfImage * 5,
    );
    File('$pathToFileCache/${counter.toString()}-($imageName)croppedImage.png')
        .writeAsBytesSync(imagePackage.encodeJpg(croppedImage));
    setState(() {
      pathToCroppedImage =
          '$pathToFileCache/${counter.toString()}-($imageName)croppedImage.png';
      counter++;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('Disposed');
    textDetector.close();
  }
}

class ResultData {
  String name;
  String nric;
  String address;
  String religion;
  String gender;

  bool warganegara;

  ResultData(
      {this.name,
      this.nric,
      this.address,
      this.religion,
      this.gender,
      this.warganegara});
}

enum ViewState { IDLE, BUSY }
