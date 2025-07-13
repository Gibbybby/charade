class Topic {
  final String id;
  final String nameKey;
  final String imagePath;
  final String category;
  final List<String> words;

  const Topic({
    required this.id,
    required this.nameKey,
    required this.imagePath,
    required this.category,
    required this.words,
  });
}


const List<Topic> topics = [
  Topic(
    id: '1',
    nameKey: 'topic_animal',
    imagePath: 'assets/topics/topic_animal.png',
    category: 'kids',
    words: ['Hund', 'Katze', 'Elefant', 'Pferd', 'Löwe', 'Affe', 'Vogel', 'Fisch', 'Bär', 'Frosch'],
  ),
  Topic(
    id: '2',
    nameKey: 'topic_car',
    imagePath: 'assets/topics/topic_car.png',
    category: 'kids',
    words: ['Auto', 'Reifen', 'Benzin', 'Lenkrad', 'Motor', 'Hupe', 'Bremse', 'Kupplung', 'Scheinwerfer', 'Gurt'],
  ),
  Topic(
    id: '3',
    nameKey: 'topic_drugs',
    imagePath: 'assets/topics/topic_drugs.png',
    category: 'party',
    words: ['Alkohol', 'Zigarette', 'Cannabis', 'Pille', 'Kokain', 'Dealer', 'Rausch', 'Sucht', 'Joint', 'Amphetamin'],
  ),
  Topic(
    id: '4',
    nameKey: 'topic_film',
    imagePath: 'assets/topics/topic_film.png',
    category: 'films',
    words: ['Schauspieler', 'Regisseur', 'Kamera', 'Action', 'Komödie', 'Drama', 'Drehbuch', 'Kino', 'Trailer', 'Oscar'],
  ),
  Topic(
    id: '5',
    nameKey: 'topic_geography',
    imagePath: 'assets/topics/topic_geography.png',
    category: 'kids',
    words: ['Land', 'Stadt', 'Fluss', 'Berg', 'Meer', 'Wüste', 'Insel', 'Wald', 'See', 'Kontinent'],
  ),
  Topic(
    id: '6',
    nameKey: 'topic_jobs',
    imagePath: 'assets/topics/topic_jobs.png',
    category: 'kids',
    words: ['Lehrer', 'Polizist', 'Arzt', 'Bäcker', 'Pilot', 'Mechaniker', 'Koch', 'Friseur', 'Ingenieur', 'Soldat'],
  ),
  Topic(
    id: '7',
    nameKey: 'topic_music',
    imagePath: 'assets/topics/topic_music.png',
    category: 'party',
    words: ['Gitarre', 'Lied', 'Trommel', 'Mikrofon', 'Bass', 'Beat', 'DJ', 'Konzert', 'Rhythmus', 'Kopfhörer'],
  ),
  Topic(
    id: '8',
    nameKey: 'topic_party',
    imagePath: 'assets/topics/topic_party.png',
    category: 'party',
    words: ['Tanzen', 'Getränk', 'Musik', 'DJ', 'Club', 'Shot', 'Kater', 'Freunde', 'Feiern', 'Disco'],
  ),
  Topic(
    id: '9',
    nameKey: 'topic_serien',
    imagePath: 'assets/topics/topic_serien.png',
    category: 'films',
    words: ['Staffel', 'Episode', 'Netflix', 'Stream', 'Drama', 'Cliffhanger', 'Charakter', 'Spannung', 'Intro', 'Abspann'],
  ),
  Topic(
    id: '10',
    nameKey: 'topic_sex',
    imagePath: 'assets/topics/topic_sex.png',
    category: 'party',
    words: ['Kondom', 'Liebe', 'Intim', 'Verhütung', 'Aufklärung', 'Beziehung', 'Zärtlichkeit', 'Erotik', 'Verlangen', 'Partner'],
  ),
  Topic(
    id: '11',
    nameKey: 'topic_sport',
    imagePath: 'assets/topics/topic_sport.png',
    category: 'kids',
    words: ['Fußball', 'Tennis', 'Basketball', 'Laufen', 'Turnen', 'Schwimmen', 'Boxen', 'Volleyball', 'Radfahren', 'Skifahren'],
  ),
  Topic(
    id: '12',
    nameKey: 'topic_stars',
    imagePath: 'assets/topics/topic_stars.png',
    category: 'party',
    words: ['Sänger', 'Schauspieler', 'Influencer', 'Promi', 'Red Carpet', 'Interview', 'Skandal', 'Fan', 'VIP', 'Klatsch'],
  ),
];

