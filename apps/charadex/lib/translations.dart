import 'app_state.dart';

class Translations {
  static final _localizedStrings = {
    'de': {
      'topics': 'Themen',
      'start': 'Start',
      'start_game': 'Spiel starten',
      'timer_title': 'Timer einstellen',
      'cancel': 'Abbrechen',
      'ok': 'OK',
      'seconds': '{value} Sekunden',
      'well_done': '🎉 Gut gemacht!',
      'correct_incorrect': '{correct} Richtig, {incorrect} Falsch',
      'back_to_menu': 'Zum Menü',
      'tilt_phone': 'Handy kippen',
      'topic_labels': {
        'Autos': 'Autos',
        'Geografie': 'Geografie',
        'Sport': 'Sport',
        'Rund um Sex': 'Rund um Sex',
        'Drogen': 'Drogen',
        'Party': 'Party',
        'Film': 'Film',
        'Serien': 'Serien',
        'Stars': 'Stars',
        'Tiere': 'Tiere',
        'Jobs': 'Jobs',
        'Music': 'Musik',
      },
    },
    'us': {
      'topics': 'Topics',
      'start': 'Start',
      'start_game': 'Start Game',
      'timer_title': 'Set Timer',
      'cancel': 'Cancel',
      'ok': 'OK',
      'seconds': '{value} seconds',
      'well_done': '🎉 Well done!',
      'correct_incorrect': '{correct} correct, {incorrect} incorrect',
      'back_to_menu': 'Back to menu',
      'tilt_phone': 'Tilt phone',
      'topic_labels': {
        'Autos': 'Cars',
        'Geografie': 'Geography',
        'Sport': 'Sports',
        'Rund um Sex': 'About Sex',
        'Drogen': 'Drugs',
        'Party': 'Party',
        'Film': 'Movies',
        'Serien': 'Series',
        'Stars': 'Celebrities',
        'Tiere': 'Animals',
        'Jobs': 'Jobs',
        'Music': 'Music',
      },
    },
    'es': {
      'topics': 'Temas',
      'start': 'Comenzar',
      'start_game': 'Iniciar juego',
      'timer_title': 'Configurar temporizador',
      'cancel': 'Cancelar',
      'ok': 'Aceptar',
      'seconds': '{value} segundos',
      'well_done': '🎉 ¡Bien hecho!',
      'correct_incorrect': '{correct} correctas, {incorrect} incorrectas',
      'back_to_menu': 'Volver al menú',
      'tilt_phone': 'Inclina el teléfono',
      'topic_labels': {
        'Autos': 'Coches',
        'Geografie': 'Geografía',
        'Sport': 'Deportes',
        'Rund um Sex': 'Sobre sexo',
        'Drogen': 'Drogas',
        'Party': 'Fiesta',
        'Film': 'Películas',
        'Serien': 'Series',
        'Stars': 'Famosos',
        'Tiere': 'Animales',
        'Jobs': 'Trabajos',
        'Music': 'Música',
      },
    },
  };

  /// General translation method with placeholder support
  static String t(String key, {Map<String, String>? params}) {
    final lang = AppState.getLanguageCode();
    final dynamic value =
        _localizedStrings[lang]?[key] ?? _localizedStrings['en']?[key] ?? key;

    if (value is String) {
      if (params != null) {
        return params.entries.fold(value, (acc, entry) {
          return acc.replaceAll('{${entry.key}}', entry.value);
        });
      }
      return value;
    }

    // fallback if the value is not a String (e.g. a Map)
    return key;
  }

  /// Translate topic names like "Autos", "Sport", etc.
  static String topicLabel(String label) {
    final lang = AppState.getLanguageCode();
    final labels = _localizedStrings[lang]?['topic_labels'];
    if (labels is Map<String, String>) {
      return labels[label] ?? label;
    }
    return label;
  }
}
