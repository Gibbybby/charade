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

  // Countdown-Zeit (z. B. 60 Sekunden)
  int _timerSeconds = 60;
  int get timerSeconds => _timerSeconds;

  void setTimer(int seconds) {
    _timerSeconds = seconds;
    notifyListeners();
  }

  // --- Wortverwaltung ---

  // Liste aller Wörter der ausgewählten Topics
  List<String> _words = [];
  List<bool> _answers = [];
  int _currentWordIndex = 0;

  // Getter für Wörter und Antworten
  List<String> get words => List.unmodifiable(_words);
  List<bool> get answers => List.unmodifiable(_answers);

  /// Setzt die Wortliste (z. B. aus den gewählten Topics), mischt sie und startet bei Index 0.
  void setWords(List<String> words) {
    _words = List<String>.from(words)..shuffle();
    _currentWordIndex = 0;
    _answers.clear();
    notifyListeners();
  }

  /// Gibt das aktuell angezeigte Wort zurück.
  String get currentWord {
    if (_words.isEmpty) return '';
    return _words[_currentWordIndex];
  }

  /// Speichert die Antwort für das aktuelle Wort: true = richtig, false = übersprungen.
  void recordAnswer(bool isCorrect) {
    _answers.add(isCorrect);
    notifyListeners();
  }

  /// Springt zum nächsten Wort in der Liste (zyklisch).
  void nextWord() {
    if (_words.isEmpty) return;
    _currentWordIndex = (_currentWordIndex + 1) % _words.length;
    notifyListeners();
  }

  /// Setzt den Wort-Index zurück (optional).
  void resetWords() {
    _currentWordIndex = 0;
    _answers.clear();
    notifyListeners();
  }
}
