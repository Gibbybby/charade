import 'package:flutter/foundation.dart';
import 'models/topic.dart';

class AppState extends ChangeNotifier {
  // Ausgewählte Topics (nur temporär gespeichert)
  List<Topic> _selectedTopics = [];
  List<Topic> get selectedTopics => _selectedTopics;

  void setSelectedTopics(List<Topic> topics) {
    _selectedTopics = topics;
    notifyListeners();
  }

  // Gewählte Sprache
  String _language = 'Deutsch';
  String get language => _language;

  void setLanguage(String newLang) {
    _language = newLang;
    notifyListeners();
  }

  // Countdown-Zeit (z. B. 60 Sekunden)
  int _timerSeconds = 60;
  int get timerSeconds => _timerSeconds;

  void setTimer(int seconds) {
    _timerSeconds = seconds;
    notifyListeners();
  }
}
