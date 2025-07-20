import 'package:flutter/material.dart';

import 'word_list_screen.dart';

class ResultsScreen extends StatelessWidget {
  final List<WordResult> results;
  const ResultsScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1C),
      appBar: AppBar(
        title: const Text('Ergebnis'),
        backgroundColor: const Color(0xFF0F0F1C),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final res = results[index];
          return ListTile(
            title: Text(
              res.word,
              style: TextStyle(
                color: res.correct ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
