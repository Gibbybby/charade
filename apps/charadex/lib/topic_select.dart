import 'dart:io' show Platform;
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

class TopicSelectScreen extends StatelessWidget {
  const TopicSelectScreen({Key? key}) : super(key: key);

  void _onStartPressed() {
    // TODO: Handle "Start" button tap
  }

  @override
  Widget build(BuildContext context) {
    final fabWidth = MediaQuery.of(context).size.width * 0.9; // 90% der Breite

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
                  children: [
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_car.png',
                      label: 'Autos',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_geography.png',
                      label: 'Geography',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_sport.png',
                      label: 'Sport',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_film.png',
                      label: 'Film',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_animal.png',
                      label: 'Animals',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_jobs.png',
                      label: 'Jobs',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_stars.png',
                      label: 'Stars',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_car.png',
                      label: 'Autos',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_geography.png',
                      label: 'Geography',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_sport.png',
                      label: 'Sport',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_film.png',
                      label: 'Film',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_animal.png',
                      label: 'Animals',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_jobs.png',
                      label: 'Jobs',
                    ),
                    _buildTopicTile(
                      imagePath: 'assets/topics/topic_stars.png',
                      label: 'Stars',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 80,
                ), // Platz unter dem ListView für den FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: fabWidth, height: 50),
        child: FloatingActionButton.extended(
          onPressed: _onStartPressed,
          backgroundColor: Colors.white, // jetzt vollständig weiß
          label: const Text(
            'Start',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF5F8D),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopicTile({required String imagePath, required String label}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
        ],
      ),
    );
  }
}
