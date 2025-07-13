import 'package:flutter/material.dart';

class GameEndScreen extends StatelessWidget {
  final List<String> correctWords;
  final List<String> skippedWords;
  final String? lastUnmarkedWord;

  const GameEndScreen({
    super.key,
    required this.correctWords,
    required this.skippedWords,
    this.lastUnmarkedWord,
  });

  @override
  Widget build(BuildContext context) {
    final allWords = <Map<String, dynamic>>[];

    int correctIndex = 0;
    int skippedIndex = 0;
    int totalLength = correctWords.length + skippedWords.length;

    // Rekonstruiere Reihenfolge: zuerst kommen die Wörter in der Reihenfolge, wie sie gespielt wurden
    while (correctIndex < correctWords.length || skippedIndex < skippedWords.length) {
      if (correctIndex < correctWords.length) {
        if (correctWords[correctIndex] != lastUnmarkedWord) {
          allWords.add({'word': correctWords[correctIndex], 'isCorrect': true});
        }
        correctIndex++;
      }
      if (skippedIndex < skippedWords.length) {
        if (skippedWords[skippedIndex] != lastUnmarkedWord) {
          allWords.add({'word': skippedWords[skippedIndex], 'isCorrect': false});
        }
        skippedIndex++;
      }
    }

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
                itemCount: allWords.length + (lastUnmarkedWord != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < allWords.length) {
                    final entry = allWords[index];
                    final word = entry['word'] as String;
                    final isCorrect = entry['isCorrect'] as bool;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          word,
                          style: TextStyle(
                            fontSize: 16,
                            color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    // Letztes unmarkiertes Wort (grau)
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lastUnmarkedWord!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
