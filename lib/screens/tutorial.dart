import 'package:flutter/material.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  final backgroundColor = const Color(0xFF0F0F1C);
  final cardColor = const Color(0xFF1E1E2D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("So wird gespielt"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _tutorialBox(
            step: 1,
            heading: "Kategorie wählen",
            description:
            "Such dir eine oder mehrere Kategorien aus und stelle die Rundenzeit ein.",
          ),
          const SizedBox(height: 16),
          _tutorialBox(
            step: 2,
            heading: "Handy auf die Stirn",
            description:
            "Halte das Handy auf die Stirn. Deine Mitspieler sollten das Wort sehen können.",
          ),
          const SizedBox(height: 16),
          _tutorialBox(
            step: 3,
            heading: "Kippen zum Steuern",
            description: "Nach unten = richtig\nNach oben = überspringen",
          ),
          const SizedBox(height: 16),
          _tutorialBox(
            step: 4,
            heading: "Los geht's!",
            description: "Viel Spaß beim Raten!",
          ),
        ],
      ),
    );
  }

  Widget _tutorialBox({
    required int step,
    required String heading,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber[600],
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
