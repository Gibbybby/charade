import 'app_state.dart';

class Translations {
  static final _localizedStrings = {
    'de': {
      'topics': 'Themen',
      'start': 'Start',
      'timer_title': 'Timer einstellen',
      'cancel': 'Abbrechen',
      'ok': 'OK',
      'seconds': '{value} Sekunden',
      'well_done': '🎉 Gut gemacht!',
      'correct_incorrect': '{correct} Richtig, {incorrect} Falsch',
      'back_to_menu': 'Zum Menü',
    },
    'en': {
      'topics': 'Topics',
      'start': 'Start',
      'timer_title': 'Set Timer',
      'cancel': 'Cancel',
      'ok': 'OK',
      'seconds': '{value} seconds',
      'well_done': '🎉 Well done!',
      'correct_incorrect': '{correct} correct, {incorrect} incorrect',
      'back_to_menu': 'Back to menu',
    },
    'es': {
      'topics': 'Temas',
      'start': 'Comenzar',
      'timer_title': 'Configurar temporizador',
      'cancel': 'Cancelar',
      'ok': 'Aceptar',
      'seconds': '{value} segundos',
      'well_done': '🎉 ¡Bien hecho!',
      'correct_incorrect': '{correct} correctas, {incorrect} incorrectas',
      'back_to_menu': 'Volver al menú',
    },
  };

  static String t(String key, {Map<String, String>? params}) {
    final lang = AppState.getLanguageCode();
    final localized =
        _localizedStrings[lang]?[key] ?? _localizedStrings['en']?[key] ?? key;
    if (params != null) {
      return params.entries.fold(localized, (str, entry) {
        return str.replaceAll('{${entry.key}}', entry.value);
      });
    }
    return localized;
  }
}
