import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class PictureDescription extends StatefulWidget {
  final String imagePath;
  final InputImage inputImage;
  const PictureDescription(
      {@required this.imagePath, @required this.inputImage});
  @override
  _PictureDescriptionState createState() => _PictureDescriptionState();
}

class _PictureDescriptionState extends State<PictureDescription> {
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: FutureBuilder(
                  future: processImage(widget.inputImage),
                  builder: (context, snapshot) {
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
                                    fontSize: 36, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                              height: 230,
                              width: 210,
                              child: Image.file(File(widget.imagePath))),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    );
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
  }
}
