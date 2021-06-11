import 'package:flutter/material.dart';

class SplashButton extends StatelessWidget {
  final String buttonTitle;
  final Color color;
  final Color splashColor;
  final Function() onTap;
  const SplashButton(
      {@required this.buttonTitle,
      @required this.color,
      @required this.splashColor,
      @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      color: color,
      child: InkWell(
        //splashFactory: InkRipple.splashFactory,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        splashColor: splashColor,
        onTap: onTap,
        child: Container(
          height: 77,
          width: 250,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Center(
            child: Text(
              buttonTitle,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class SplashButtonCamera extends StatelessWidget {
  final Color color;
  final Color splashColor;
  final Function() onTap;
  const SplashButtonCamera(
      {@required this.color, @required this.splashColor, @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(48))),
      color: color,
      child: InkWell(
        //splashFactory: InkRipple.splashFactory,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        splashColor: splashColor,
        onTap: onTap,
        child: Container(
          height: 80,
          width: 80,
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(48)),
          ),
          child: Center(child: Icon(Icons.camera)),
        ),
      ),
    );
  }
}
