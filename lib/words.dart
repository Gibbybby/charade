import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

class Words {
  static Map<String, List<String>> _data = {};

  static Future<void> load(Locale locale) async {
    final path = 'assets/words/${locale.languageCode}.json';
    final jsonStr = await rootBundle.loadString(path);
    final Map<String, dynamic> map = json.decode(jsonStr);
    _data = {
      for (var entry in map.entries)
        entry.key: List<String>.from(entry.value as List)
    };
  }

  static List<String> forCategory(String id) {
    return _data[id] ?? [];
  }
}
