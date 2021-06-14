import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:camera_scan/main.dart';
import 'package:camera_scan/screens/picture_description.dart';
import 'package:camera_scan/screens/start_page.dart';
import 'package:camera_scan/widgets/splash_button.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imagePackage;

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController cameraController;
  int startingPointX = 0;
  int startingPointY = 0;
  int widthOfImage = 0;
  int heightOfImage = 0;
  String pathToFileCache = '/data/user/0/com.example.camera_scan/cache';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        //fit: StackFit.expand,
        children: [
          CameraPreview(cameraController),
          cameraOverlay(
              padding: 30, aspectRatio: 1.5, color: Color(0x55000000)),
          Positioned(
              //left: 40,
              right: (constraints.maxWidth / 2) - 40,
              left: (constraints.maxWidth / 2) - 40,
              bottom: 40,
              child: SplashButtonCamera(
                  color: Color(0xffFFB0B0),
                  splashColor: Colors.grey,
                  onTap: () async {
                    final image = await cameraController.takePicture();
                    final inputImage = InputImage.fromFilePath(image.path);
                    final fileOfImage = File(image.path);
                    final imageHeight = Image.file(File(image.path)).height;
                    final imageWidth = Image.file(File(image.path)).width;

                    print(
                        'Height of imageCaptured : $imageHeight \n Width of imageCaptured:$imageWidth');
                    print('Path to file :${image.path}');
                    print('Name of file :${image.name}');
                    print('Starting point of X : $startingPointX');
                    print('Starting point of Y : $startingPointY');
                    print('Width of image to be crop:  $widthOfImage');
                    print('Height of image to be crop: $heightOfImage');
                    var decodedImage =
                        imagePackage.decodeImage(fileOfImage.readAsBytesSync());
                    print(
                        'Height of decodedImage : ${decodedImage.height}\n Width of decodedImage:${decodedImage.width}');
                    final croppedImage = imagePackage.copyCrop(
                      decodedImage,
                      startingPointY * 5,
                      startingPointX * 6,
                      heightOfImage * 6,
                      widthOfImage * 5,
                    );

                    print(
                        'Height of imagecropped: ${croppedImage.height}\n Width of imagecropped:${croppedImage.width}');
                    double aspectRation =
                        croppedImage.width / croppedImage.height;
                    File('$pathToFileCache/(${image.name})croppedImage.png')
                        .writeAsBytesSync(imagePackage.encodeJpg(croppedImage));
                    print('Aspect Ratio for the: $aspectRation');
                    Navigator.push(
                        context,
                        FadeRoute(
                            page: PictureDescription(
                          height: heightOfImage,
                          width: widthOfImage,
                          inputImage: inputImage,
                          imagePath:
                              '$pathToFileCache/(${image.name})croppedImage.png',
                          imageName: image.name,
                          startingPointX: startingPointX,
                          startingPointY: startingPointY,
                        )));
                  }))
        ],
      );
    });
  }

  Widget cameraOverlay({double padding, double aspectRatio, Color color}) {
    return LayoutBuilder(builder: (context, constraints) {
      double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
      double horizontalPadding;
      double verticalPadding;

      if (parentAspectRatio < aspectRatio) {
        horizontalPadding = padding;
        verticalPadding = (constraints.maxHeight -
                ((constraints.maxWidth - 2 * padding) / aspectRatio)) /
            2;
      } else {
        verticalPadding = padding;
        horizontalPadding = (constraints.maxWidth -
                ((constraints.maxHeight - 2 * padding) * aspectRatio)) /
            2;
      }
      print('This is constraint maxWidth : ${constraints.maxWidth.toInt()}');
      print('This is constraint maxHeight : ${constraints.maxHeight.toInt()}');
      print('This is parent aspect ratio : $parentAspectRatio');
      print('This is vertical padding: $verticalPadding');
      print('This is horizontal padding: $horizontalPadding');
      startingPointX = horizontalPadding.toInt();
      startingPointY = verticalPadding.toInt();
      widthOfImage = (constraints.maxWidth - (horizontalPadding * 2)).toInt();
      heightOfImage = (constraints.maxHeight - (verticalPadding * 2)).toInt();
      return Stack(fit: StackFit.expand, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Container(width: horizontalPadding, color: color)),
        Align(
            alignment: Alignment.centerRight,
            child: Container(width: horizontalPadding, color: color)),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: color)),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: color)),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          decoration:
              BoxDecoration(border: Border.all(color: Color(0xffFFB0B0))),
        )
      ]);
    });
  }
}
