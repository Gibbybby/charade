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
    "id": "adult",
    "name": "18+",
    "titleKey": "menu_adult",
    "isSelected": false,
  },
  {
    "id": "films",
    "name": "Films",
    "titleKey": "menu_films",
    "isSelected": false,
  },
  {
    "id": "education",
    "name": "Education",
    "titleKey": "menu_education",
    "isSelected": false,
  },
];

/// Bildthemen mit ID, Titel-Schlüssel für Übersetzung,
/// zugehörigen Menüpunkten und Wortliste
const List<Map<String, dynamic>> imageItems = [
  {
    "id": "cars",
    "label": "Cars",
    "fitMenuItemIds": [""],
    "imagePath": "assets/topics/cars.png",
  },
  {
    "id": "history",
    "label": "History",
    "fitMenuItemIds": ["education"],
    "imagePath": "assets/topics/history.png",
  },
  {
    "id": "geography",
    "label": "Geography",
    "fitMenuItemIds": ["education"],
    "imagePath": "assets/topics/geography.png",
  },
  {
    "id": "countries",
    "label": "Countries",
    "fitMenuItemIds": ["education"],
    "imagePath": "assets/topics/countries.jpeg",
  },
  {
    "id": "capitals",
    "label": "Capitals",
    "fitMenuItemIds": ["education"],
    "imagePath": "assets/topics/capitals.jpeg",
  },
  {
    "id": "brands",
    "label": "Brands",
    "fitMenuItemIds": [],
    "imagePath": "assets/topics/brands.jpeg",
  },
  {
    "id": "christmas",
    "label": "Christmas",
    "fitMenuItemIds": [],
    "imagePath": "assets/topics/christmas.jpeg",
  },
  {
    "id": "games",
    "label": "Games",
    "fitMenuItemIds": [],
    "imagePath": "assets/topics/games.jpeg",
  },
  {
    "id": "music",
    "label": "Music",
    "fitMenuItemIds": [""],
    "imagePath": "assets/topics/music.png",
  },
  {
    "id": "animals",
    "label": "Animals",
    "fitMenuItemIds": ["kids", "education"],
    "imagePath": "assets/topics/animals.png",
  },
  {
    "id": "jobs",
    "label": "Jobs",
    "fitMenuItemIds": ["kids", "education"],
    "imagePath": "assets/topics/jobs.png",
  },
  {
    "id": "superheros",
    "label": "Superheros",
    "fitMenuItemIds": ["kids"],
    "imagePath": "assets/topics/superheros.jpeg",
  },
  {
    "id": "food",
    "label": "Food",
    "fitMenuItemIds": ["kids"],
    "imagePath": "assets/topics/food.jpeg",
  },
  {
    "id": "sex",
    "label": "Sex",
    "fitMenuItemIds": ["adult"],
    "imagePath": "assets/topics/sex.jpeg",
  },
  {
    "id": "intoxicants",
    "label": "Intoxicants",
    "fitMenuItemIds": ["adult"],
    "imagePath": "assets/topics/intoxicants.jpeg",
  },
  {
    "id": "sport_general",
    "label": "Sport",
    "fitMenuItemIds": ["sport"],
    "imagePath": "assets/topics/sport.jpeg",
  },
  {
    "id": "football",
    "label": "Football",
    "fitMenuItemIds": ["sport"],
    "imagePath": "assets/topics/football.png",
  },
  {
    "id": "basketball",
    "label": "Basketball",
    "fitMenuItemIds": ["sport"],
    "imagePath": "assets/topics/basketball.png",
  },
  {
    "id": "tennis",
    "label": "Tennis",
    "fitMenuItemIds": ["sport"],
    "imagePath": "assets/topics/tennis.jpeg",
  },
  {
    "id": "films",
    "label": "Films",
    "fitMenuItemIds": ["films"],
    "imagePath": "assets/topics/films/films.png",
  },
  {
    "id": "series",
    "label": "Series",
    "fitMenuItemIds": ["films"],
    "imagePath": "assets/topics/films/series.png",
  },
  {
    "id": "netflix",
    "label": "Netflix",
    "fitMenuItemIds": ["films"],
    "imagePath": "assets/topics/films/netflix.jpeg",
  },
  {
    "id": "disney",
    "label": "Disney",
    "fitMenuItemIds": ["kids", "films"],
    "imagePath": "assets/topics/films/disney.jpeg",
  },
  {
    "id": "paramount",
    "label": "Paramount",
    "fitMenuItemIds": ["films"],
    "imagePath": "assets/topics/films/paramount.jpeg",
  },
  {
    "id": "prime",
    "label": "Prime",
    "fitMenuItemIds": ["films"],
    "imagePath": "assets/topics/films/prime.jpeg",
  },
  {
    "id": "breakingbad",
    "label": "Breaking Bad",
    "fitMenuItemIds": ["films"],
    "imagePath": "assets/topics/films/breakingbad.jpeg",
  },
  {
    "id": "harrypotter",
    "label": "Harry Potter",
    "fitMenuItemIds": ["films"],
    "imagePath": "assets/topics/films/harrypotter.jpeg",
  },
  {
    "id": "stars",
    "label": "Stars",
    "fitMenuItemIds": [""],
    "imagePath": "assets/topics/stars.jpeg",
  },
];
