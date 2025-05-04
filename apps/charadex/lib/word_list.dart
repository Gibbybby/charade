// word_list.dart

import 'package:flutter/material.dart';

class WordList extends StatelessWidget {
  final List<String> words;
  final int currentIndex;
  final bool showList;

  const WordList({
    Key? key,
    required this.words,
    required this.currentIndex,
    required this.showList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showList) {
      final int listCount =
          currentIndex >= words.length ? words.length : currentIndex + 1;

      return ListView.builder(
        // Vertikale Liste
        shrinkWrap: true,
        itemCount: listCount,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(words[index], style: const TextStyle(fontSize: 16)),
            ),
          );
        },
      );
    }

    return Center(
      child: Text(
        words[currentIndex],
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      ),
    );
  }
}
