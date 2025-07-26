import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;

class GameSettings {
  static const _durationKey = 'roundDuration';
  static const _movementsKey = 'movementsEnabled';
  static const _tutorialKey = 'startTutorial';
  static const _darkModeKey = 'darkMode';
  static const _languageKey = 'languageCode';
  static Duration roundDuration = const Duration(seconds: 90);
  static bool movementsEnabled = true;
  static bool startTutorial = true;
  static bool darkMode = true;
  static String languageCode = ui.window.locale.languageCode;

  static final notifier = ValueNotifier<int>(0);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final sec = prefs.getInt(_durationKey);
    if (sec != null) {
      roundDuration = Duration(seconds: sec);
    }
    movementsEnabled = prefs.getBool(_movementsKey) ?? true;
    startTutorial = prefs.getBool(_tutorialKey) ?? true;
    darkMode = prefs.getBool(_darkModeKey) ?? true;
    languageCode = prefs.getString(_languageKey) ?? ui.window.locale.languageCode;
    if (!['en', 'de', 'es', 'fr', 'hr', 'pt'].contains(languageCode)) {
      languageCode = 'en';
    }
  }

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_durationKey, roundDuration.inSeconds);
    await prefs.setBool(_movementsKey, movementsEnabled);
    await prefs.setBool(_tutorialKey, startTutorial);
    await prefs.setBool(_darkModeKey, darkMode);
    await prefs.setString(_languageKey, languageCode);
    notifier.value++;
  }
}
