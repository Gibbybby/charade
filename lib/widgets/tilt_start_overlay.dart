// tilt_start_overlay.dart
import 'package:flutter/material.dart';

class TiltStartOverlay extends StatelessWidget {
  const TiltStartOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                'Tilt your phone to start',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: 0,
            child: Image.asset(
              'assets/tutorial/correct.png',
              width: 200,
              height: 200,
            ),
          ),
          Positioned(
            bottom: -50,
            right: 0,
            child: Image.asset(
              'assets/tutorial/incorrect.png',
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}