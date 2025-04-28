import 'dart:io' show Platform;
import 'package:charadex/countdown.dart';
import 'package:flutter/material.dart';

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

class TopicSelectScreen extends StatefulWidget {
  const TopicSelectScreen({Key? key}) : super(key: key);

  @override
  _TopicSelectScreenState createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  // Mehrfachauswahl: Set für ausgewählte Indizes
  final Set<int> _selectedIndices = {};

  void _onStartPressed() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const Countdown()));
  }

  final List<Map<String, String>> _topics = [
    {'imagePath': 'assets/topics/topic_car.png', 'label': 'Autos'},
    {'imagePath': 'assets/topics/topic_geography.png', 'label': 'Geographie'},
    {'imagePath': 'assets/topics/topic_sport.png', 'label': 'Sport'},
    {'imagePath': 'assets/topics/topic_film.png', 'label': 'Film'},
    {'imagePath': 'assets/topics/topic_animal.png', 'label': 'Tiere'},
    {'imagePath': 'assets/topics/topic_jobs.png', 'label': 'Jobs'},
    {'imagePath': 'assets/topics/topic_stars.png', 'label': 'Stars'},
  ];

  @override
  Widget build(BuildContext context) {
    final fabWidth = MediaQuery.of(context).size.width * 0.9;
    final bool canStart = _selectedIndices.isNotEmpty;

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
            child: ListView(
              children: [
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
                    Expanded(
                      child: Text(
                        'Themen',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(_topics.length, (index) {
                    final topic = _topics[index];
                    return _buildTopicTile(
                      index: index,
                      imagePath: topic['imagePath']!,
                      label: topic['label']!,
                    );
                  }),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
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
              color: Color(0xFFFF5F8D).withOpacity(canStart ? 1.0 : 0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicTile({
    required int index,
    required String imagePath,
    required String label,
  }) {
    final bool isSelected = _selectedIndices.contains(index);

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
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              label,
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
  }
}
