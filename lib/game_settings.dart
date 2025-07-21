import 'package:shared_preferences/shared_preferences.dart';

class GameSettings {
  static const _durationKey = 'roundDuration';
  static Duration roundDuration = const Duration(seconds: 60);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final sec = prefs.getInt(_durationKey);
    if (sec != null) {
      roundDuration = Duration(seconds: sec);
    }
  }

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_durationKey, roundDuration.inSeconds);
  }
}
