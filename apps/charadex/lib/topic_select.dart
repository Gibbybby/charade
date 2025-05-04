import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'countdown.dart'; // Countdown-Screen import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartenspiele',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TopicSelectScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Modell für ein Thema mit Bild, Label und zugehörigen Wörtern
class Topic {
  final String imagePath;
  final String label;
  final List<String> words;

  const Topic({
    required this.imagePath,
    required this.label,
    required this.words,
  });
}

class TopicSelectScreen extends StatefulWidget {
  const TopicSelectScreen({Key? key}) : super(key: key);

  @override
  _TopicSelectScreenState createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  final Set<int> _selectedIndices = {};

  static const List<Topic> _topics = [
    Topic(
      imagePath: 'assets/topics/topic_car.png',
      label: 'Autos',
      words: ['Auto1', 'Auto2', 'Auto3', 'Auto4', 'Auto5'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_geography.png',
      label: 'Geografie',
      words: [
        'Geografie1',
        'Geografie2',
        'Geografie3',
        'Geografie4',
        'Geografie5',
      ],
    ),
    Topic(
      imagePath: 'assets/topics/topic_sport.png',
      label: 'Sport',
      words: ['Sport1', 'Sport2', 'Sport3', 'Sport4', 'Sport5'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_film.png',
      label: 'Film',
      words: ['Film1', 'Film2', 'Film3', 'Film4', 'Film5'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_animal.png',
      label: 'Tiere',
      words: ['Tier1', 'Tier2', 'Tier3', 'Tier4', 'Tier5'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_jobs.png',
      label: 'Jobs',
      words: ['Job1', 'Job2', 'Job3', 'Job4', 'Job5'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_stars.png',
      label: 'Stars',
      words: ['Star1', 'Star2', 'Star3', 'Star4', 'Star5'],
    ),
  ];

  void _onStartPressed() {
    // Alle Wörter der ausgewählten Themen sammeln
    final selectedWords =
        _selectedIndices.expand((i) => _topics[i].words).toList();

    // Navigation zum Countdown-Screen mit den gesammelten Wörtern
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => Countdown(words: selectedWords)));
  }

  @override
  Widget build(BuildContext context) {
    final bool canStart = _selectedIndices.isNotEmpty;
    final fabWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF5F8D), Color(0xFFFFA726)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Kopfzeile
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Expanded(
                      child: Text(
                        'Themen',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 24),
                // Grid mit Mehrfach-Auswahl
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: List.generate(_topics.length, (index) {
                      final topic = _topics[index];
                      final isSelected = _selectedIndices.contains(index);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedIndices.remove(index);
                            } else {
                              _selectedIndices.add(index);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                isSelected
                                    ? Border.all(color: Colors.white, width: 3)
                                    : null,
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage(topic.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              color: Colors.black26,
                              child: Text(
                                topic.label,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Start-Button, nur aktiv wenn mindestens ein Thema ausgewählt
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: fabWidth, height: 50),
        child: FloatingActionButton.extended(
          onPressed: canStart ? _onStartPressed : null,
          backgroundColor: canStart ? Colors.white : Colors.white54,
          label: Text(
            'Start',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF5F8D).withOpacity(canStart ? 1.0 : 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
