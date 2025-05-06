import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charadex/topic_select.dart';
import 'package:charadex/app_state.dart';

class CharadePartyHomePage extends StatefulWidget {
  const CharadePartyHomePage({Key? key}) : super(key: key);

  @override
  State<CharadePartyHomePage> createState() => _CharadePartyHomePageState();
}

class _CharadePartyHomePageState extends State<CharadePartyHomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _confettiController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  Animation<double>? _fadeAnimation;

  final Random _random = Random();
  final List<ConfettiPiece> _confettiPieces = [];

  final List<String> _flagAssets = [
    'assets/flags/de.png',
    'assets/flags/us.png',
    'assets/flags/es.png',
  ];
  int _currentFlagIndex = 0;

  @override
  void initState() {
    super.initState();

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

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    )..repeat();

    for (int i = 0; i < 50; i++) {
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
    _controller.dispose();
    _confettiController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onStartGamePressed() {
    _controller.reverse().then((_) {
      _controller.forward();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TopicSelectScreen()),
          );
        }
      });
    });
  }

  void _toggleFlag() {
    setState(() {
      _currentFlagIndex = (_currentFlagIndex + 1) % _flagAssets.length;
      final flagPath = _flagAssets[_currentFlagIndex];
      if (flagPath.contains('de')) {
        AppState.setLanguageCode('de');
      } else if (flagPath.contains('us')) {
        AppState.setLanguageCode('us');
      } else if (flagPath.contains('es')) {
        AppState.setLanguageCode('es');
      }
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
                colors: [Color(0xFFFF5F8D), Color(0xFFFFA726)],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: ConfettiPainter(_confettiPieces)),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: _toggleFlag,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            _flagAssets[_currentFlagIndex],
                            width: 70,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 150),
                        child: Column(
                          children: [
                            FadeTransition(
                              opacity:
                                  _fadeAnimation ??
                                  const AlwaysStoppedAnimation(1.0),
                              child: Image.asset(
                                'assets/welcome_pic.png',
                                width: 120,
                              ),
                            ),
                            Image.asset(
                              'assets/charade_party_title.png',
                              width: 300,
                            ),
                          ],
                        ),
                      ),
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
