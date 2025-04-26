import 'package:flutter/material.dart';
import 'topic_select.dart'; // Import TopicSelectScreen

class PlayerModeScreen extends StatelessWidget {
  const PlayerModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double boxWidth = 320;
    const double boxHeight = 260;
    const double spacing = 30;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Who's Playing?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF512DA8),
                ),
              ),
              const SizedBox(height: 40),
              _buildModeButton(
                imagePath: 'assets/solo.png',
                imageWidth: 120, // Smaller Solo image
                imageHeight: 120,
                title: 'Solo',
                subtitle: 'play alone',
                color: Colors.blueAccent,
                width: boxWidth,
                height: boxHeight,
                onTap: () {
                  Future.microtask(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TopicSelectScreen(),
                      ),
                    );
                  });
                },
              ),
              const SizedBox(height: spacing),
              _buildModeButton(
                imagePath: 'assets/team.png',
                imageWidth: 200, // Bigger Team image
                imageHeight: 150,
                title: 'Teams',
                subtitle: 'team battle',
                color: Colors.pinkAccent,
                width: boxWidth,
                height: boxHeight,
                onTap: () {
                  Future.microtask(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TopicSelectScreen(),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton({
    Icon? icon,
    String? imagePath,
    double imageWidth = 100,
    double imageHeight = 100,
    required String title,
    required String subtitle,
    required Color color,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.contain,
              )
            else if (icon != null)
              icon,
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 0),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
