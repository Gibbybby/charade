import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/topic.dart';

class AppState extends ChangeNotifier {
  // Keys für SharedPreferences
  static const _keyLanguageCode = 'languageCode';
  static const _keyTimerSeconds = 'timerSeconds';

  late SharedPreferences _prefs;

  // Standardeinstellungen
  String _languageCode = 'en';
  int _timerSeconds = 60;

  // Ausgewählte Topics (nur temporär gespeichert)
  List<Topic> _selectedTopics = [];
  List<Topic> get selectedTopics => List.unmodifiable(_selectedTopics);

  // Wortverwaltung
  List<String> _words = [];
  List<bool> _answers = [];
  int _currentWordIndex = 0;

  AppState() {
    _loadFromPrefs();
  }

  /// Initialisiert SharedPreferences und lädt gespeicherte Werte
  Future<void> _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _languageCode = _prefs.getString(_keyLanguageCode) ?? _languageCode;
    _timerSeconds = _prefs.getInt(_keyTimerSeconds) ?? _timerSeconds;
    notifyListeners();
  }

  // --- Themen-Auswahl ---
  void setSelectedTopics(List<Topic> topics) {
    _selectedTopics = List<Topic>.from(topics);
    notifyListeners();
  }

  // --- Sprache als Locale-Code ('de', 'en', ...) ---
  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);

  /// Setzt den Sprach-Code, speichert und benachrichtigt Zuhörer
  void setLanguageCode(String code) {
    if (_languageCode == code) return;
    _languageCode = code;
    _prefs.setString(_keyLanguageCode, code);
    notifyListeners();
  }

  // --- Countdown-Zeit (z. B. 60 Sekunden) ---
  int get timerSeconds => _timerSeconds;

  /// Setzt den Timer, speichert und benachrichtigt Zuhörer
  void setTimer(int seconds) {
    _timerSeconds = seconds;
    _prefs.setInt(_keyTimerSeconds, seconds);
    notifyListeners();
  }

  // --- Wortverwaltung ---
  List<String> get words => List.unmodifiable(_words);
  List<bool> get answers => List.unmodifiable(_answers);

  /// Setzt neue Wortliste, mischt, startet bei 0
  void setWords(List<String> words) {
    _words = List<String>.from(words)..shuffle();
    _currentWordIndex = 0;
    _answers.clear();
    notifyListeners();
  }

  /// Gibt aktuelles Wort zurück oder leeren String, wenn Spiel vorbei
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

  /// Geht zum nächsten Wort, falls vorhanden – sonst Spielende
  void nextWord() {
    if (_words.isEmpty) return;

    if (_currentWordIndex < _words.length - 1) {
      _currentWordIndex++;
    } else {
      _currentWordIndex = _words.length;
    }
    notifyListeners();
  }

  /// Setzt Wortstatus zurück (z. B. für neues Spiel)
  void resetWords() {
    _currentWordIndex = 0;
    _answers.clear();
    notifyListeners();
  }
}
