import 'package:camera/camera.dart';
import 'package:camera_scan/main.dart';
import 'package:camera_scan/screens/picture_description.dart';
import 'package:camera_scan/screens/start_page.dart';
import 'package:camera_scan/widgets/splash_button.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController cameraController;

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
        fit: StackFit.expand,
        children: [
          CameraPreview(cameraController),
          cameraOverlay(padding: 30, aspectRatio: 1, color: Color(0x55000000)),
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

                    Navigator.push(
                        context,
                        FadeRoute(
                            page: PictureDescription(
                          imagePath: image.path,
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
            1.7;
      } else {
        verticalPadding = padding;
        horizontalPadding = (constraints.maxWidth -
                ((constraints.maxHeight - 2 * padding) * aspectRatio)) /
            2;
      }
      print('This is constraint maxWidth : ${constraints.maxWidth}');
      print('This is constraint maxHeight : ${constraints.maxHeight}');
      print('This is parent aspect ratio : $parentAspectRatio');
      print('This is vertical padding: $verticalPadding');
      print('This is horizontal padding: $horizontalPadding');
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
