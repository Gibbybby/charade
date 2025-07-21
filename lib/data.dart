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
  {
    "id": "films",
    "name": "Breaking Bad",
    "titleKey": "menu_films",
    "isSelected": false,
  },
  {
    "id": "films",
    "name": "Films",
    "titleKey": "menu_films",
    "isSelected": false,
  },
  {
    "id": "films",
    "name": "Films",
    "titleKey": "menu_films",
    "isSelected": false,
  },
  {
    "id": "films",
    "name": "Films",
    "titleKey": "menu_films",
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
    "titleKeys": ["animals"],
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
    "titleKeys": ["basketball"],
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
    "titleKeys": ["cars", "autos"],
    "fitMenuItemId": "kids",
    "imagePath": "assets/topics/cars.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "films",
    "titleKeys": ["films"],
    "fitMenuItemId": "films",
    "imagePath": "assets/topics/films.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "football",
    "titleKeys": ["football"],
    "fitMenuItemId": "sport",
    "imagePath": "assets/topics/football.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "geography",
    "titleKeys": ["geography"],
    "fitMenuItemId": "kids",
    "imagePath": "assets/topics/geography.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "history",
    "titleKeys": ["history"],
    "fitMenuItemId": "kids",
    "imagePath": "assets/topics/history.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "jobs",
    "titleKeys": ["jobs"],
    "fitMenuItemId": "kids",
    "imagePath": "assets/topics/jobs.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "music",
    "titleKeys": ["music"],
    "fitMenuItemId": "films",
    "imagePath": "assets/topics/music.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "series",
    "titleKeys": ["series"],
    "fitMenuItemId": "films",
    "imagePath": "assets/topics/series.png",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },{
    "id": "sport",
    "titleKeys": ["sport"],
    "fitMenuItemId": "sport",
    "imagePath": "assets/topics/sport.jpeg",
    "words": [
      "word1",
      "word2",
      "word3"
    ],
  },
];
