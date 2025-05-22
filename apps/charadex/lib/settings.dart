import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  // Die Sprache-Codes, nicht die Display-Namen
  static const _languageCodes = ['de', 'en'];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final appState = Provider.of<AppState>(context);
    final sliderValue = appState.timerSeconds.clamp(10, 120).toDouble();
    final currentLangCode =
        appState.languageCode; // angenommen ist jetzt 'de' oder 'en'

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          loc.settings,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
              Text(
                loc.languageLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: currentLangCode,
                items:
                    _languageCodes.map((code) {
                      final display =
                          code == 'de'
                              ? loc.languageGerman
                              : loc.languageEnglish;
                      return DropdownMenuItem(
                        value: code,
                        child: Text(display),
                      );
                    }).toList(),
                onChanged: (newCode) {
                  if (newCode != null) {
                    appState.setLanguageCode(newCode);
                  }
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                loc.timerLabel,
                style: const TextStyle(
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
                label: '${sliderValue.round()} ${loc.secondsAbbr}',
                onChanged: (newValue) {
                  appState.setTimer(newValue.round());
                },
                activeColor: Colors.white,
                inactiveColor: Colors.white38,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  loc.currentTimer(appState.timerSeconds),
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
