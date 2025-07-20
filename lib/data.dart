// lib/data.dart

/// Menüeinträge mit ID, Name (für spätere interne Verwendung) und titleKey (für Lokalisierung)
const List<Map<String, dynamic>> menuItems = [
  {
    "id": "all",
    "name": "All",
    "titleKey": "menu_all",
    "isSelected": true,
  },
  {
    "id": "kids",
    "name": "Kids",
    "titleKey": "menu_kids",
    "isSelected": false,
  },
  {
    "id": "sport",
    "name": "Sport",
    "titleKey": "menu_sport",
    "isSelected": false,
  },
  {
    "id": "party",
    "name": "Party",
    "titleKey": "menu_party",
    "isSelected": false,
  },
  {
    "id": "films",
    "name": "Films",
    "titleKey": "menu_films",
    "isSelected": false,
  },
];

/// Bildthemen mit ID, Titel-Schlüssel für Übersetzung, zugehörigem Menüpunkt, Pfad und Wortliste
const List<Map<String, dynamic>> imageItems = [
  {
    "id": "animals",
    "titleKey": "animals",
    "fitMenuItemId": "kids",
    "imagePath": "assets/topics/animals.png",
    "words": [
      "word1",
      "word2"
      "word3"
    ],
  },
  {
    "id": "basketball",
    "titleKey": "basketball",
    "fitMenuItemId": "sport",
    "imagePath": "assets/topics/basketball.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },
  {
    "id": "cars",
    "titleKey": "cars",
    "fitMenuItemId": "kids",
    "imagePath": "assets/topics/cars.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "films",
    "titleKey": "films",
    "fitMenuItemId": "films",
    "imagePath": "assets/topics/films.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "football",
    "titleKey": "football",
    "fitMenuItemId": "sport",
    "imagePath": "assets/topics/football.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "geography",
    "titleKey": "geography",
    "fitMenuItemId": "kids",
    "imagePath": "assets/topics/geography.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "history",
    "titleKey": "history",
    "fitMenuItemId": "kids",
    "imagePath": "assets/topics/history.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "jobs",
    "titleKey": "jobs",
    "fitMenuItemId": "kids",
    "imagePath": "assets/topics/jobs.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "music",
    "titleKey": "music",
    "fitMenuItemId": "films",
    "imagePath": "assets/topics/music.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "series",
    "titleKey": "series",
    "fitMenuItemId": "films",
    "imagePath": "assets/topics/series.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "sport",
    "titleKey": "sport",
    "fitMenuItemId": "sport",
    "imagePath": "assets/topics/sport.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },
];
