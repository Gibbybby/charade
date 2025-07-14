import 'package:flutter/material.dart';

class BottomControlPanel extends StatelessWidget {
  final int seconds;
  final VoidCallback onStartGame;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const BottomControlPanel({
    super.key,
    required this.seconds,
    required this.onStartGame,
    required this.onIncrease,
    required this.onDecrease,
  });

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, // Weißer Hintergrund für Kreis
        ),
        child: Icon(icon, size: 20, color: Colors.deepPurple), // Icon in Farbe
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Zeit + Icons in gemeinsamer Kapsel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _iconButton(icon: Icons.remove, onTap: onDecrease),
                const SizedBox(width: 14),
                Text(
                  _formatTime(seconds),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                _iconButton(icon: Icons.add, onTap: onIncrease),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Start-Button
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: onStartGame,
                child: const Text(
                  'Spiel starten',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
