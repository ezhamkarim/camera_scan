import 'package:camera_scan/screens/picture_description.dart';
import 'package:flutter/material.dart';

class ExctractData extends ChangeNotifier {
  ResultData _resultData;
  ViewState _viewState;

  setState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  setResultData(ResultData resultData) {
    _resultData = resultData;
    notifyListeners();
  }

  ViewState get getViewState => _viewState;
  ResultData get getResultData => _resultData;
}
