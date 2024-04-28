import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isSwitched = true;

  // Method to update email
  void updateUsername() {
    isSwitched = !isSwitched;
    notifyListeners(); // Notify listeners that the value has changed
  }
}
