import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Countdown extends StatefulWidget {
  const Countdown({Key? key}) : super(key: key);

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> with TickerProviderStateMixin {
  late AnimationController _confettiController;
  final Random _random = Random();
  final List<ConfettiPiece> _confettiPieces = [];

  // Countdown state
  int _countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Force landscape orientation only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Start countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });

    // Confetti animation (infinite)
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    )..repeat();

    // Create fewer confetti pieces for background
    for (int i = 0; i < 20; i++) {
      _confettiPieces.add(
        ConfettiPiece(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.0005 + _random.nextDouble() * 0.0015,
          swayAmplitude: 20 + _random.nextDouble() * 10,
          swaySpeed: 1 + _random.nextDouble() * 2,
          size: 6 + _random.nextDouble() * 8,
          color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    // Reset orientations
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background: white and conditional confetti
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child:
                _countdown > 0
                    ? AnimatedBuilder(
                      animation: _confettiController,
                      builder: (context, child) {
                        _updateConfetti();
                        return CustomPaint(
                          painter: ConfettiPainter(_confettiPieces),
                        );
                      },
                    )
                    : null,
          ),
          // Centered animated countdown text
          if (_countdown > 0)
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: Text(
                  '$_countdown',
                  key: ValueKey<int>(_countdown),
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
          // Short instruction text at bottom during countdown
          if (_countdown > 0)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Text(
                'Kippe↓ richtig • Kippe↑ überspringen',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
        ],
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
  double swayAmplitude;
  double swaySpeed;
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
    final double time = DateTime.now().millisecondsSinceEpoch / 1000.0;

    for (var piece in confettiPieces) {
      final paint = Paint()..color = piece.color;
      double swayOffset = piece.swayAmplitude * sin(time * piece.swaySpeed);
      double dx = piece.x * size.width + swayOffset;
      double dy = piece.y * size.height;
      canvas.drawCircle(Offset(dx, dy), piece.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
