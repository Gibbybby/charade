import 'package:flutter/material.dart';

class TiltStartOverlay extends StatelessWidget {
  const TiltStartOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
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
    );
  }
}
