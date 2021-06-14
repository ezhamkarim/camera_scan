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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: FutureBuilder(
                  future: processImage(widget.inputImage),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
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
                            Text(dataProcessed),
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

    for (int i = 0; i < recognisedText.blocks.length; i++) {
      print('Text found : ${recognisedText.blocks[i].text}');
    }

    dataProcessed = recognisedText.text;
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
