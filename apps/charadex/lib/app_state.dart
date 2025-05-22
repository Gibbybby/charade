import 'package:flutter/foundation.dart';

// <-- hier den relativen Pfad zu deinem Topic-Modell anpassen:
import 'models/topic.dart';

class AppState extends ChangeNotifier {
  // Selected Topics
  List<Topic> _selectedTopics = [];
  List<Topic> get selectedTopics => _selectedTopics;
  void setSelectedTopics(List<Topic> topics) {
    _selectedTopics = topics;
    notifyListeners();
  }

  // Sprache
  String _language = 'Deutsch';
  String get language => _language;
  void setLanguage(String newLang) {
    _language = newLang;
    notifyListeners();
  }

  // Timer
  int _timerSeconds = 60;
  int get timerSeconds => _timerSeconds;
  void setTimer(int seconds) {
    _timerSeconds = seconds;
    notifyListeners();
  }
}
