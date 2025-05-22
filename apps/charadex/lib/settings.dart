import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  final List<String> _languages = const ['Deutsch', 'Englisch'];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final sliderValue = appState.timerSeconds.clamp(10, 120).toDouble();

    return Scaffold(
      extendBodyBehindAppBar: true, // AppBar über den Hintergrund
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Einstellungen',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF5F8D), Color(0xFFFFA726)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
          child: ListView(
            children: [
              const Text(
                'Sprache',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
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
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Timer (Sekunden)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: sliderValue,
                min: 10,
                max: 120,
                divisions: 11,
                label: '${sliderValue.round()} s',
                onChanged: (newValue) {
                  appState.setTimer(newValue.round());
                },
                activeColor: Colors.white,
                inactiveColor: Colors.white38,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Aktueller Timer: ${appState.timerSeconds} Sekunden',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
