import 'dart:io';

import 'package:flutter/material.dart';

class PictureDescription extends StatefulWidget {
  final String imagePath;

  const PictureDescription({@required this.imagePath});
  @override
  _PictureDescriptionState createState() => _PictureDescriptionState();
}

class _PictureDescriptionState extends State<PictureDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
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
                  child: Image.file(File(widget.imagePath))),
            ],
          ),
        ),
      )),
    );
  }
}
