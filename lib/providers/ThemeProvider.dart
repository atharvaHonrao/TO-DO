import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  var isSwitched = true;
  void updateTheme() {
    isSwitched = !isSwitched;
    notifyListeners();
  }
}