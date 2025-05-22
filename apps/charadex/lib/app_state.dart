import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'models/topic.dart';

class AppState extends ChangeNotifier {
  // Ausgewählte Topics (nur temporär gespeichert)
  List<Topic> _selectedTopics = [];
  List<Topic> get selectedTopics => List.unmodifiable(_selectedTopics);

  void setSelectedTopics(List<Topic> topics) {
    _selectedTopics = List<Topic>.from(topics);
    notifyListeners();
  }

  // Sprache als Locale-Code ('de', 'en', ...)
  String _languageCode = 'de';
  String get languageCode => _languageCode;

  /// Gibt das aktuelle Locale-Objekt zurück
  Locale get locale => Locale(_languageCode);

  /// Setzt den Sprach-Code und benachrichtigt Zuhörer
  void setLanguageCode(String code) {
    if (_languageCode == code) return;
    _languageCode = code;
    notifyListeners();
  }

  // Countdown-Zeit (z. B. 60 Sekunden)
  int _timerSeconds = 60;
  int get timerSeconds => _timerSeconds;

  void setTimer(int seconds) {
    _timerSeconds = seconds;
    notifyListeners();
  }

  // --- Wortverwaltung ---
  List<String> _words = [];
  List<bool> _answers = [];
  int _currentWordIndex = 0;

  List<String> get words => List.unmodifiable(_words);
  List<bool> get answers => List.unmodifiable(_answers);

  /// Setzt neue Wortliste und startet bei 0
  void setWords(List<String> words) {
    _words = List<String>.from(words)..shuffle();
    _currentWordIndex = 0;
    _answers.clear();
    notifyListeners();
  }

  /// Gibt das aktuelle Wort zurück oder leeren String, wenn Spiel vorbei
  String get currentWord {
    if (_words.isEmpty || _currentWordIndex >= _words.length) {
      return '';
    }
    return _words[_currentWordIndex];
  }

  /// Antwort speichern (nur wenn Wort vorhanden)
  void recordAnswer(bool isCorrect) {
    if (_currentWordIndex < _words.length) {
      _answers.add(isCorrect);
      notifyListeners();
    }
  }

  /// Geht zum nächsten Wort, falls vorhanden – sonst bleibt leer
  void nextWord() {
    if (_words.isEmpty) return;

    if (_currentWordIndex < _words.length - 1) {
      _currentWordIndex++;
    } else {
      // Spiel vorbei: Index auf Länge setzen → currentWord wird ""
      _currentWordIndex = _words.length;
    }

    notifyListeners();
  }

  /// Setzt Wortstatus zurück (z. B. für neues Spiel)
  void resetWords() {
    _currentWordIndex = 0;
    _answers.clear();
    notifyListeners();
  }
}
