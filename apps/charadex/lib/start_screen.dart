import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charadex/start_screen_animation.dart';
import 'package:charadex/settings.dart';
import 'package:charadex/topic_select.dart';

class CharadePartyHomePage extends StatefulWidget {
  const CharadePartyHomePage({Key? key}) : super(key: key);

  @override
  State<CharadePartyHomePage> createState() => _CharadePartyHomePageState();
}

class _CharadePartyHomePageState extends State<CharadePartyHomePage>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _fadeController;
  late final AnimationController _confettiController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  final Random _random = Random();
  final List<ConfettiPiece> _confettiPieces = [];

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0.9,
      upperBound: 1.0,
    )..forward();
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    )..repeat();

    _confettiPieces.addAll(generateConfettiPieces(_random, 50));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _onStartGamePressed() async {
    await _scaleController.reverse();
    await _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => TopicSelectScreen()));
    }
  }

  void _onSettingsPressed() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _confettiController,
        builder: (context, child) {
          updateConfettiPieces(_confettiPieces, _random);
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
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.gear_solid,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _onSettingsPressed,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 100),
                        child: Column(
                          children: [
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Image.asset(
                                'assets/images/startscreen_logo.png',
                                width: 100,
                              ),
                            ),
                            Image.asset(
                              'assets/images/startscreen_title.png',
                              width: 250,
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
                            'Spiel starten',
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
}
