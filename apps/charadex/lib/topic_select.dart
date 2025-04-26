import 'package:flutter/material.dart';

class TopicSelectScreen extends StatelessWidget {
  const TopicSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Zentriert die gesamte Row
                crossAxisAlignment:
                    CrossAxisAlignment
                        .center, // Stellt sicher, dass der Text vertikal zentriert bleibt
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Pick a Topic!",
                        style: const TextStyle(
                          fontSize: 42, // Die Textgröße wie gewünscht
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1, // Nur eine Zeile erlaubt
                        overflow:
                            TextOverflow
                                .ellipsis, // Falls der Text zu lang ist, wird "..." angezeigt
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3, // 3 Kategorien pro Reihe
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8, // Kästchen etwas höher
                  children: [
                    _buildTopicTile(
                      color: Colors.purpleAccent,
                      icon: Icons.work,
                      label: 'Berufe',
                    ),
                    _buildTopicTile(
                      color: Colors.lightBlueAccent,
                      icon: Icons.theater_comedy,
                      label: 'Pantomime',
                    ),
                    _buildTopicTile(
                      color: Colors.pinkAccent,
                      icon: Icons.child_care,
                      label: 'Jugend-Wörter',
                    ),
                    _buildTopicTile(
                      color: Colors.orangeAccent,
                      icon: Icons.toys,
                      label: 'Für Kinder',
                    ),
                    _buildTopicTile(
                      color: Colors.greenAccent,
                      icon: Icons.pets,
                      label: 'Tiere',
                    ),
                    _buildTopicTile(
                      color: Colors.blueGrey,
                      icon: Icons.public,
                      label: 'Geografie',
                    ),
                    _buildTopicTile(
                      color: Colors.deepPurpleAccent,
                      icon: Icons.music_note,
                      label: 'Musik',
                    ),
                    _buildTopicTile(
                      color: Colors.redAccent,
                      icon: Icons.movie,
                      label: 'Filme',
                    ),
                    _buildTopicTile(
                      color: Colors.indigoAccent,
                      icon: Icons.tv,
                      label: 'Serien',
                    ),
                    _buildTopicTile(
                      color: Colors.tealAccent,
                      icon: Icons.sports_soccer,
                      label: 'Sport',
                    ),
                    _buildTopicTile(
                      color: Colors.orange,
                      icon: Icons.fastfood,
                      label: 'Essen',
                    ),
                    _buildTopicTile(
                      color: Colors.blue,
                      icon: Icons.history_edu,
                      label: 'Boomerwörter',
                    ),
                    _buildTopicTile(
                      color: Colors.pink,
                      icon: Icons.shopping_bag,
                      label: 'Marken',
                    ),
                    _buildTopicTile(
                      color: Colors.deepOrange,
                      icon: Icons.book,
                      label: 'Geschichte',
                    ),
                    _buildTopicTile(
                      color: Colors.lightGreen,
                      icon: Icons.breakfast_dining,
                      label: 'Frühstücken',
                    ),
                    _buildTopicTile(
                      color: Colors.purple,
                      icon: Icons.favorite,
                      label: 'Rund um Sex',
                    ),
                    _buildTopicTile(
                      color: Colors.limeAccent,
                      icon: Icons.videogame_asset,
                      label: 'Videospiele',
                    ),
                    _buildTopicTile(
                      color: Colors.cyan,
                      icon: Icons.science,
                      label: 'Wissenschaft',
                    ),
                    _buildTopicTile(
                      color: Colors.green,
                      icon: Icons.sports_soccer,
                      label: 'Fußball',
                    ),
                    _buildTopicTile(
                      color: Colors.red,
                      icon: Icons.celebration,
                      label: 'Silvester',
                    ),
                    _buildTopicTile(
                      color: Colors.blueAccent,
                      icon: Icons.star,
                      label: 'Schauspieler',
                    ),
                    _buildTopicTile(
                      color: Colors.deepPurple,
                      icon: Icons.cake,
                      label: 'Party',
                    ),
                    _buildTopicTile(
                      color: Colors.brown,
                      icon: Icons.local_bar,
                      label: 'Rauschmittel',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Handle Next button
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicTile({
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
