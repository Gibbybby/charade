import 'package:flutter/material.dart';

class WordListScreen extends StatelessWidget {
  final List<String> words;
  const WordListScreen({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1C),
      appBar: AppBar(
        title: const Text('Wörter'),
        backgroundColor: const Color(0xFF0F0F1C),
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              words[index],
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
