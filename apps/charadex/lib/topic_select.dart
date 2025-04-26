// topic_select.dart
import 'package:flutter/material.dart';

class TopicSelectScreen extends StatelessWidget {
  const TopicSelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Pick a Topic!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C1C4B),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildTopicTile(
                      color: Colors.purpleAccent,
                      icon: Icons.movie,
                      label: 'Movies',
                    ),
                    _buildTopicTile(
                      color: Colors.lightBlueAccent,
                      icon: Icons.pets,
                      label: 'Animals',
                    ),
                    _buildTopicTile(
                      color: Colors.pinkAccent,
                      icon: Icons.directions_run,
                      label: 'Celebrities',
                    ),
                    _buildTopicTile(
                      color: Colors.orangeAccent,
                      icon: Icons.star,
                      label:
                          'Collecties', // Looks like a typo in your screenshot ("Calecties")
                    ),
                    _buildTopicTile(
                      color: Colors.blueGrey.shade100,
                      icon: Icons.add,
                      label: 'Custom Packs',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Handle Next button
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicTile({
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
