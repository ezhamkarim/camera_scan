import 'package:camera/camera.dart';
import 'package:camera_scan/extractdatanotifier.dart';
import 'package:camera_scan/screens/start_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExctractData(),
      child: MaterialApp(
        home: StartPage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Gotham',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
