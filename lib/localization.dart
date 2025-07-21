import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'words.dart';

class AppLocalizations {
  final Locale locale;
  final Map<String, String> _values;
  AppLocalizations(this.locale, this._values);

  static const supportedLocales = [
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('hr'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) async {
    final data = await rootBundle
        .loadString('lib/l10n/app_${locale.languageCode}.arb');
    final map = Map<String, dynamic>.from(json.decode(data));
    await Words.load(locale);
    return AppLocalizations(
        locale, map.map((k, v) => MapEntry(k, v.toString())));
  }

  String t(String key, {Map<String, String>? params}) {
    var str = _values[key] ?? key;
    params?.forEach((k, v) {
      str = str.replaceAll('{$k}', v);
    });
    return str;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) =>
      ['en', 'de', 'es', 'fr', 'hr'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
