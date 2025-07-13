import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_end.dart';

class GameScreen extends StatefulWidget {
  final List<String> words;
  final int gameDurationInSeconds;

  const GameScreen({
    super.key,
    required this.words,
    required this.gameDurationInSeconds,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> remainingWords;
  late Timer wordTimer;
  late Timer countdownTimer;

  String? currentWord;
  int remainingSeconds = 0;

  @override
  void initState() {
    super.initState();

    // Nur Querformat rechts
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);

    // Wörterliste kopieren & mischen
    remainingWords = List.of(widget.words)..shuffle(Random());

    // Zeit setzen
    remainingSeconds = widget.gameDurationInSeconds;

    // Start Timer
    _nextWord(); // Sofort 1. Wort
    wordTimer = Timer.periodic(const Duration(seconds: 3), (_) => _nextWord());
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    setState(() {
      remainingSeconds--;
    });

    if (remainingSeconds <= 0) {
      _endGame();
    }
  }

  void _nextWord() {
    if (remainingWords.isEmpty) {
      _endGame();
      return;
    }

    setState(() {
      currentWord = remainingWords.removeAt(0);
    });
  }

  void _endGame() {
    wordTimer.cancel();
    countdownTimer.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GameEndScreen()),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    wordTimer.cancel();
    countdownTimer.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Wort zentriert anzeigen
            Center(
              child: Text(
                currentWord ?? '',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Countdown oben rechts
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatTime(remainingSeconds),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
