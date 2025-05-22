import 'dart:math';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:charadex/start_screen_animation.dart';

class ConfettiPiece {
  double x, y, speed, size, swayAmplitude, swaySpeed;
  Color color;

  ConfettiPiece({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.swayAmplitude,
    required this.swaySpeed,
    required this.color,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> confettiPieces;

  ConfettiPainter(this.confettiPieces);

  @override
  void paint(Canvas canvas, Size size) {
    final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
    for (var piece in confettiPieces) {
      final paint = Paint()..color = piece.color;
      final sway = piece.swayAmplitude * sin(time * piece.swaySpeed);
      final dx = piece.x * size.width + sway;
      final dy = piece.y * size.height;
      canvas.drawCircle(Offset(dx, dy), piece.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// Erzeugt eine Liste von zufälligen Konfetti-Teilen.
List<ConfettiPiece> generateConfettiPieces(Random random, int count) {
  return List.generate(count, (_) {
    return ConfettiPiece(
      x: random.nextDouble(),
      y: random.nextDouble(),
      speed: 0.0005 + random.nextDouble() * 0.0015,
      swayAmplitude: 20 + random.nextDouble() * 10,
      swaySpeed: 1 + random.nextDouble() * 2,
      size: 6 + random.nextDouble() * 8,
      color: Colors.primaries[random.nextInt(Colors.primaries.length)],
    );
  });
}

/// Aktualisiert die Positionen der Konfetti-Teile für die Animation.
void updateConfettiPieces(List<ConfettiPiece> pieces, Random random) {
  for (var piece in pieces) {
    piece.y += piece.speed;
    if (piece.y > 1.2) {
      piece.y = -0.1;
      piece.x = random.nextDouble();
    }
  }
}
