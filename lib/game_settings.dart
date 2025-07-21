import 'package:shared_preferences/shared_preferences.dart';

class GameSettings {
  static const _durationKey = 'roundDuration';
  static const _movementsKey = 'movementsEnabled';
  static const _tutorialKey = 'startTutorial';
  static Duration roundDuration = const Duration(seconds: 60);
  static bool movementsEnabled = false;
  static bool startTutorial = true;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final sec = prefs.getInt(_durationKey);
    if (sec != null) {
      roundDuration = Duration(seconds: sec);
    }
    movementsEnabled = prefs.getBool(_movementsKey) ?? false;
    startTutorial = prefs.getBool(_tutorialKey) ?? true;
  }

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_durationKey, roundDuration.inSeconds);
    await prefs.setBool(_movementsKey, movementsEnabled);
    await prefs.setBool(_tutorialKey, startTutorial);
  }
}
