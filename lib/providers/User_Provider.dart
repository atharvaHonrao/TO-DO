import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _username;
  UserProvider(this._username);
  String get email => _username;

  // Method to update email
  void updateUsername(String newEmail) {
    _username = newEmail;
    notifyListeners(); // Notify listeners that the value has changed
  }
}
