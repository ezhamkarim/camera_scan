import 'package:camera_scan/screens/camera_screen.dart';
import 'package:camera_scan/widgets/splash_button.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'Scan your IC',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            Container(
                height: 230,
                width: 210,
                child: Image.asset(
                  'assets/images/startImage.png',
                  fit: BoxFit.fill,
                )),
            SplashButton(
                buttonTitle: 'Mari Mulakan',
                color: Color(0xffFFB0B0),
                splashColor: Colors.grey,
                onTap: () {
                  Navigator.push(context, FadeRoute(page: CameraScreen()));
                })
          ],
        ),
      )),
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
