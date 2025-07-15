// lib/data.dart

import 'dart:io';

/// Liste der Menüelemente
const List<Map<String, dynamic>> menuItems = [
  {"title": "All", "isSelected": true},
  {"title": "Kids", "isSelected": false},
  {"title": "Sport", "isSelected": false},
  {"title": "Party", "isSelected": false},
  {"title": "Films", "isSelected": false},
];

/// Liste der Bildpfade
const List<String> imagePaths = [
  'assets/topics/animal.png',
  'assets/topics/car.png',
  'assets/topics/drugs.png',
  'assets/topics/film.png',
  'assets/topics/geo.png',
  'assets/topics/jobs.png',
  'assets/topics/music.png',
  'assets/topics/party.png',
  'assets/topics/series.png',
  'assets/topics/sex.png',
  'assets/topics/sport.png',
  'assets/topics/stars.png',
];
