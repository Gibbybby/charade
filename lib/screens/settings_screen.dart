import 'package:charadex/screens/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter/services.dart';
import '../game_settings.dart';
import '../localization.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = GameSettings.languageCode;
  Duration _selectedDuration = GameSettings.roundDuration;
  bool _movements = GameSettings.movementsEnabled;
  bool _startTutorial = GameSettings.startTutorial;
  bool _darkMode = GameSettings.darkMode;

  Color get backgroundColor => Theme.of(context).scaffoldBackgroundColor;
  Color get cardColor => Theme.of(context).cardColor;
  Color get purple => Theme.of(context).colorScheme.primary;

  @override
  void initState() {
    super.initState();
    _selectedDuration = GameSettings.roundDuration;
    _movements = GameSettings.movementsEnabled;
    _startTutorial = GameSettings.startTutorial;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          AppLocalizations.of(context).t('settings'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // Language
          _settingsTile(
            icon: Icons.language,
            title: AppLocalizations.of(context).t('languageLabel'),
            value: _selectedLanguage == 'en'
                ? AppLocalizations.of(context).t('languageEnglish')
                : AppLocalizations.of(context).t('languageGerman'),
            onTap: () {
              setState(() {
                _selectedLanguage = _selectedLanguage == 'en' ? 'de' : 'en';
                GameSettings.languageCode = _selectedLanguage;
              });
              GameSettings.save();
            },
          ),

          const SizedBox(height: 12),

          // Dark mode toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.brightness_6, color: Colors.amber[600]),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).t('darkMode'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: _darkMode,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    setState(() {
                      _darkMode = val;
                      GameSettings.darkMode = val;
                    });
                    GameSettings.save();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Tutorial-Link
          _settingsTile(
            icon: Icons.menu_book,
            title: AppLocalizations.of(context).t('howToPlay'),
            value: AppLocalizations.of(context).t('learnRules'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TutorialScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          Text(AppLocalizations.of(context).t('gameSettings'),
              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Round time (Cupertino Timer Picker)
          _settingsTile(
            icon: Icons.timer,
            title: AppLocalizations.of(context).t('roundTime'),
            value: _formatDuration(_selectedDuration),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: cardColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) {
                  return SizedBox(
                    height: 250,
                    child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.ms,
                      initialTimerDuration: _selectedDuration,
                      minuteInterval: 1,
                      secondInterval: 1,
                      onTimerDurationChanged: (duration) {
                        final cappedDuration = duration < const Duration(seconds: 15)
                            ? const Duration(seconds: 15)
                            : duration > const Duration(minutes: 5)
                                ? const Duration(minutes: 5)
                                : duration;
                        setState(() {
                          _selectedDuration = cappedDuration;
                          GameSettings.roundDuration = cappedDuration;
                        });
                        GameSettings.save();
                      },
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 12),

          // Movements toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.directions_run, color: Colors.amber[600]),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).t('movements'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context).t('movementsDesc'),
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _movements,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    setState(() {
                      _movements = val;
                      GameSettings.movementsEnabled = val;
                    });
                    GameSettings.save();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Start tutorial toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.play_circle_outline, color: Colors.amber[600]),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).t('startTutorial'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context).t('startTutorialDesc'),
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _startTutorial,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    setState(() {
                      _startTutorial = val;
                      GameSettings.startTutorial = val;
                    });
                    GameSettings.save();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 App-Informationen
          Text(
            AppLocalizations.of(context).t('appInfo'),
            style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _infoTile(
            icon: Icons.info_outline,
            title: AppLocalizations.of(context).t('appVersion'),
            value: "1.1.0",
          ),

          const SizedBox(height: 12),

          // Rate App
          InkWell(
            onTap: () async {
              final review = InAppReview.instance;
              if (await review.isAvailable()) {
                review.requestReview();
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.star_rate, color: Colors.amber[600]),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).t('rateApp'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(value,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))
                  ]),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54)
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))
                ]),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds min";
  }
}
