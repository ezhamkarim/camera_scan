import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imagePackage;

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
  String pathToCroppedImage = "";
  int counter = 0;
  String nric = "";
  String name = "";
  String address = "";
  bool isWarganegara = false;
  String gender = "";
  String religion = "";
  int nricIndex = 0;
  int nameIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: FutureBuilder(
                  future: processImage(widget.inputImage),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Text(dataProcessed ?? 'No data'),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'NRIC',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              nric,
                              style: TextStyle(fontSize: 14),
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

  Future<void> processImage(InputImage inputImage) async {
    final recognisedText = await textDetector.processImage(inputImage);
    print('Found ${recognisedText.blocks.length} textBlocks');
    print('Whole text:  ${recognisedText.text} ');
    dataProcessed = recognisedText.text;
    for (int i = 0; i < recognisedText.blocks.length; i++) {
      print('Text of $i :  ${recognisedText.blocks[i].text} ');
      if (recognisedText.blocks[i].text.contains('-', 6)) {
        nric = recognisedText.blocks[i].text;
        nricIndex = i + 1;
      }

      if (i == nricIndex) {
        name = recognisedText.blocks[i].text;
        nameIndex = i + 1;
      }

      if (i == nameIndex) {
        address = recognisedText.blocks[i].text;
      }

      if (recognisedText.blocks[i].text.contains('WARGANEGARA')) {
        isWarganegara = true;
      } else {
        print('Text sepatutnya warganegara: ${recognisedText.blocks[i].text}');
      }

      if (i == recognisedText.blocks.length - 1) {
        if (recognisedText.blocks[i].text.contains('LELAKI')) {
          int indexOfFirstLetter =
              recognisedText.blocks[i].text.indexOf('LELAKI');
          gender = recognisedText.blocks[i].text.substring(indexOfFirstLetter);
        }
        if (recognisedText.blocks[i].text.contains('PEREMPUAN')) {
          int indexOfFirstLetter =
              recognisedText.blocks[i].text.indexOf('PEREMPUAN');
          gender = recognisedText.blocks[i].text.substring(indexOfFirstLetter);
        }
      }

      // if (recognisedText.blocks[i].text.contains(RegExp(r"^[A-Z]*$"))) {
      //   name = recognisedText.blocks[i].text;
      // }
    }
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
}
