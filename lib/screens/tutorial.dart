import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  final backgroundColor = const Color(0xFF0F0F1C);
  final cardColor = const Color(0xFF1E1E2D);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("How to Play"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _tutorialBox(
            step: 1,
            heading: "Choose a category",
            description:
                "Pick one or more categories and set the round time.",
          ),
          const SizedBox(height: 16),
          _tutorialBox(
            step: 2,
            heading: "Phone on the forehead",
            description:
                "Hold the phone to your forehead so your team can read the word.",
          ),
          const SizedBox(height: 16),
          _tutorialBox(
            step: 3,
            heading: "Tilt to control",
            description: "Down = correct\nUp = skip",
            extras: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/tutorial/correct.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Image.asset(
                      'assets/tutorial/incorrect.png',
                      height: 100,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _tutorialBox(
            step: 4,
            heading: "Let's go!",
            description: "Have fun guessing!",
          ),
        ],
      ),
    );
  }

  Widget _tutorialBox({
    required int step,
    required String heading,
    required String description,
    List<Widget> extras = const [],
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
                ...extras,
              ],
            ),
          )
        ],
      ),
    );
  }
}
