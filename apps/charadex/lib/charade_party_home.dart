import 'dart:math';
import 'package:flutter/material.dart';

class CharadePartyHomePage extends StatefulWidget {
  const CharadePartyHomePage({Key? key}) : super(key: key);

  @override
  State<CharadePartyHomePage> createState() => _CharadePartyHomePageState();
}

class _CharadePartyHomePageState extends State<CharadePartyHomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;

  final Random _random = Random();
  final List<ConfettiPiece> _confettiPieces = [];

  @override
  void initState() {
    super.initState();

    // Bounce animation for button
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.9,
      upperBound: 1.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();

    // Confetti falling animation
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Create confetti pieces
    for (int i = 0; i < 50; i++) {
      _confettiPieces.add(
        ConfettiPiece(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.0005 + _random.nextDouble() * 0.0015, // Very slow fall
          swayAmplitude: 20 + _random.nextDouble() * 10,
          swaySpeed: 1 + _random.nextDouble() * 2,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.02, // Slow rotation
          size: 6 + _random.nextDouble() * 8,
          color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
          shape:
              ConfettiShape.values[_random.nextInt(
                ConfettiShape.values.length,
              )],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _onStartGamePressed() {
    _controller.reverse().then((_) {
      _controller.forward();
      // TODO: Start game logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _confettiController,
        builder: (context, child) {
          _updateConfetti();
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF5F8D), // Pink
                  Color(0xFFFFA726), // Orange
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Confetti layer
                Positioned.fill(
                  child: CustomPaint(
                    painter: ConfettiPainter(
                      _confettiPieces,
                      _confettiController.value,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/charade_party_title.png', width: 300),
                      const SizedBox(height: 80),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: ElevatedButton(
                          onPressed: _onStartGamePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A3DC7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                          ),
                          child: const Text(
                            'START GAME',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateConfetti() {
    for (var piece in _confettiPieces) {
      piece.y += piece.speed;
      piece.rotation += piece.rotationSpeed;
      if (piece.y > 1.2) {
        piece.y = -0.1;
        piece.x = _random.nextDouble();
        piece.rotation = _random.nextDouble() * 2 * pi;
      }
    }
  }
}

enum ConfettiShape { circle, square, triangle, star }

class ConfettiPiece {
  double x;
  double y;
  double speed;
  double size;
  double swayAmplitude;
  double swaySpeed;
  double rotation = 0;
  double rotationSpeed;
  Color color;
  ConfettiShape shape;

  ConfettiPiece({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.swayAmplitude,
    required this.swaySpeed,
    required this.rotationSpeed,
    required this.color,
    required this.shape,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> confettiPieces;
  final double animationValue;

  ConfettiPainter(this.confettiPieces, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var piece in confettiPieces) {
      final paint = Paint()..color = piece.color;
      final dx =
          piece.x * size.width +
          piece.swayAmplitude * sin(animationValue * 2 * pi * piece.swaySpeed);
      final dy = piece.y * size.height;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(piece.rotation);

      switch (piece.shape) {
        case ConfettiShape.circle:
          canvas.drawCircle(Offset.zero, piece.size / 2, paint);
          break;
        case ConfettiShape.square:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: piece.size,
              height: piece.size,
            ),
            paint,
          );
          break;
        case ConfettiShape.triangle:
          final path =
              Path()
                ..moveTo(0, -piece.size / 2)
                ..lineTo(piece.size / 2, piece.size / 2)
                ..lineTo(-piece.size / 2, piece.size / 2)
                ..close();
          canvas.drawPath(path, paint);
          break;
        case ConfettiShape.star:
          _drawStar(canvas, paint, piece.size / 2);
          break;
      }

      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, Paint paint, double radius) {
    const int points = 5;
    final path = Path();
    for (int i = 0; i <= points * 2; i++) {
      double angle = pi / points * i;
      double r = i.isEven ? radius : radius / 2;
      path.lineTo(r * cos(angle), r * sin(angle));
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
