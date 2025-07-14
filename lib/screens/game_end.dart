// game_end.dart
import 'package:flutter/material.dart';

class GameEndScreen extends StatelessWidget {
  final List<Map<String, dynamic>> playedWords;
  final String? lastUnmarkedWord;

  const GameEndScreen({
    super.key,
    required this.playedWords,
    this.lastUnmarkedWord,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text('Spiel beendet'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Good Job',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Words in the game:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: playedWords.length + (lastUnmarkedWord != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < playedWords.length) {
                    final word = playedWords[index]['word'] as String;
                    final isCorrect = playedWords[index]['isCorrect'] as bool;
                    final color = isCorrect ? Colors.green : Colors.red;

                    return _buildWordTile(word, color);
                  } else {
                    // Letztes unmarkiertes Wort (grau)
                    return _buildWordTile(lastUnmarkedWord!, Colors.grey);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordTile(String word, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          word,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}