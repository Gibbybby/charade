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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final res = results[index];
                return ListTile(
                  title: Text(
                    res.word,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: res.correct ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Zur\u00fcck zum Men\u00fc'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
