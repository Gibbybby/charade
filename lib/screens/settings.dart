import 'package:charadex/screens/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import '../game_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'Deutsch';
  Duration _selectedDuration = GameSettings.roundDuration;

  final backgroundColor = const Color(0xFF0F0F1C);
  final cardColor = const Color(0xFF1E1E2D);
  final purple = const Color(0xFF9B5EFF);

  @override
  void initState() {
    super.initState();
    _selectedDuration = GameSettings.roundDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Einstellungen"),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 Einstellungen-Kategorie
          const Text("Einstellungen",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Sprache
          _settingsTile(
            icon: Icons.language,
            title: "Sprache",
            value: _selectedLanguage,
            onTap: () {
              setState(() {
                _selectedLanguage =
                _selectedLanguage == 'Deutsch' ? 'Englisch' : 'Deutsch';
              });
            },
          ),

          const SizedBox(height: 12),

          // Spielzeit (Cupertino Timer Picker)
          _settingsTile(
            icon: Icons.timer,
            title: "Spielzeit",
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

          // Tutorial-Link
          _settingsTile(
            icon: Icons.menu_book,
            title: "So wird gespielt",
            value: "Regeln lernen",
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

          // 🔹 App-Informationen
          const Text("App-Informationen",
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          _infoTile(
            icon: Icons.info_outline,
            title: "App-Version",
            value: "1.1.0",
          ),

          const SizedBox(height: 12),

          // App bewerten
          InkWell(
            onTap: () async {
              final url = Uri.parse("https://www.vucak.at");
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
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
                  const Expanded(
                    child: Text(
                      "App bewerten",
                      style: TextStyle(
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
      padding: const EdgeInsets.all(16),
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
