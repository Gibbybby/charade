import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart'; // Achte darauf, dass der Pfad stimmt

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  final List<String> _languages = const ['Deutsch', 'Englisch'];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
        backgroundColor: const Color(0xFF6A3DC7),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sprache',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: appState.language,
              items:
                  _languages
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)),
                      )
                      .toList(),
              onChanged: (newLang) {
                if (newLang != null) {
                  appState.setLanguage(newLang);
                }
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 32),
            const Text(
              'Timer (Sekunden)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Slider(
              value: appState.timerSeconds.toDouble(),
              min: 3,
              max: 120,
              divisions: 11,
              label: '${appState.timerSeconds} s',
              onChanged: (newValue) {
                appState.setTimer(newValue.round());
              },
              activeColor: const Color(0xFF6A3DC7),
            ),
            Center(
              child: Text(
                'Aktueller Timer: ${appState.timerSeconds} Sekunden',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
