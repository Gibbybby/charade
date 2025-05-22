import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _language = 'Deutsch';
  int _timerSeconds = 60;

  String get language => _language;
  int get timerSeconds => _timerSeconds;

  void setLanguage(String newLang) {
    _language = newLang;
    notifyListeners();
  }

  void setTimer(int seconds) {
    _timerSeconds = seconds;
    notifyListeners();
  }
}
