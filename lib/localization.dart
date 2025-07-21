import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static const supportedLocales = [Locale('en'), Locale('de')];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Charade',
      'settings': 'Settings',
      'languageLabel': 'Language',
      'languageEnglish': 'English',
      'languageGerman': 'German',
      'darkMode': 'Dark Mode',
      'on': 'On',
      'off': 'Off',
      'howToPlay': 'How to Play',
      'learnRules': 'Learn the rules',
      'gameSettings': 'Game Settings',
      'roundTime': 'Round Time',
      'movements': 'Movements',
      'movementsDesc': 'Use buttons without gestures',
      'startTutorial': 'Start tutorial',
      'startTutorialDesc': 'Show instructions before the game',
      'appInfo': 'App Information',
      'appVersion': 'App Version',
      'rateApp': 'Rate the App',
      'start': 'Start',
      'chooseCategory': 'Choose a category',
      'chooseCategoryDesc': 'Pick one or more categories and set the round time.',
      'phoneForehead': 'Phone on the forehead',
      'phoneForeheadDesc': 'Hold the phone to your forehead so your team can read the word.',
      'tiltControl': 'Tilt to control',
      'tiltControlDesc': 'Down = correct\nUp = skip',
      'letsGo': "Let's go!",
      'haveFun': 'Have fun guessing!',
      'givePhone': 'Give the phone to another person who marks the words for you.',
      'holdPhone': 'Hold the phone to your forehead so the display faces the wall.\nThen tilt down or up to start.',
      'skip': 'Skip',
      'correct': 'Correct',
      'congratulations': 'Congratulations',
      'backToMenu': 'Back to Menu',
      'enjoyApp': 'Enjoying the app?',
      'ratePrompt': 'Would you like to rate the app?',
      'later': 'Later',
      'rate': 'Rate',
      'correctCount': '{count} correct',
      'skippedCount': '{count} skipped'
    },
    'de': {
      'title': 'Charade',
      'settings': 'Einstellungen',
      'languageLabel': 'Sprache',
      'languageEnglish': 'Englisch',
      'languageGerman': 'Deutsch',
      'darkMode': 'Dunkler Modus',
      'on': 'An',
      'off': 'Aus',
      'howToPlay': 'Spielanleitung',
      'learnRules': 'Regeln lernen',
      'gameSettings': 'Spieleinstellungen',
      'roundTime': 'Rundenzeit',
      'movements': 'Bewegungen',
      'movementsDesc': 'Mit Buttons ohne Gestensteuerung',
      'startTutorial': 'Tutorial starten',
      'startTutorialDesc': 'Vor dem Spiel die Erkl\u00e4rung',
      'appInfo': 'App-Informationen',
      'appVersion': 'App-Version',
      'rateApp': 'App bewerten',
      'start': 'Start',
      'chooseCategory': 'Kategorie w\u00e4hlen',
      'chooseCategoryDesc': 'W\u00e4hle eine oder mehrere Kategorien und stelle die Rundenzeit ein.',
      'phoneForehead': 'Handy an die Stirn',
      'phoneForeheadDesc': 'Halte das Handy an deine Stirn, damit dein Team das Wort lesen kann.',
      'tiltControl': 'Kippen zur Steuerung',
      'tiltControlDesc': 'Unten = richtig\nOben = \u00fcberspringen',
      'letsGo': 'Los geht\u2019s!',
      'haveFun': 'Viel Spa\u00df beim Raten!',
      'givePhone': 'Gib das Handy einer anderen Person, die die W\u00f6rter f\u00fcr dich markiert.',
      'holdPhone': 'Halte das Handy an deine Stirn, sodass das Display zur Wand zeigt.\nKippe dann nach unten oder oben, um zu starten.',
      'skip': 'Weiter',
      'correct': 'Richtig',
      'congratulations': 'Gl\u00fcckwunsch',
      'backToMenu': 'Zur\u00fcck zum Men\u00fc',
      'enjoyApp': 'Gef\u00e4llt dir die App?',
      'ratePrompt': 'M\u00f6chtest du die App bewerten?',
      'later': 'Sp\u00e4ter',
      'rate': 'Bewerten',
      'correctCount': '{count} richtig',
      'skippedCount': '{count} \u00fcbersprungen'
    }
  };

  String t(String key, {Map<String, String>? params}) {
    var str = _localizedValues[locale.languageCode]?[key] ?? key;
    params?.forEach((k, v) {
      str = str.replaceAll('{$k}', v);
    });
    return str;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
