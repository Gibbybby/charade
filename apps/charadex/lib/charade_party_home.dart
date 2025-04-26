import 'dart:math';
import 'package:charadex/player_mode.dart';
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
          speed: 0.0005 + _random.nextDouble() * 0.0015, // Very slow
          swayAmplitude:
              20 + _random.nextDouble() * 10, // Sway left-right pixels
          swaySpeed: 1 + _random.nextDouble() * 2, // How fast sway happens
          size: 6 + _random.nextDouble() * 8,
          color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlayerModeScreen()),
      );
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
      if (piece.y > 1.2) {
        piece.y = -0.1;
        piece.x = _random.nextDouble();
      }
    }
  }
}

class ConfettiPiece {
  double x;
  double y;
  double speed;
  double size;
  double swayAmplitude; // How wide to sway left/right
  double swaySpeed; // How fast to sway
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
  final double animationValue; // from 0.0 to 1.0

  ConfettiPainter(this.confettiPieces, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var piece in confettiPieces) {
      final paint = Paint()..color = piece.color;

      // Calculate gentle sway using sine wave
      double swayOffset =
          piece.swayAmplitude * sin(animationValue * 2 * pi * piece.swaySpeed);
      double dx = piece.x * size.width + swayOffset;
      double dy = piece.y * size.height;

      canvas.drawCircle(Offset(dx, dy), piece.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
