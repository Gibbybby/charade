import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
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
  List<String> correctWords = [];
  List<String> skippedWords = [];

  late Timer countdownTimer;
  StreamSubscription? _accelSub;

  String? currentWord;
  int remainingSeconds = 0;
  Color backgroundColor = Colors.white;

  bool isInNeutralPosition = true;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);

    remainingWords = List.of(widget.words)..shuffle(Random());
    remainingSeconds = widget.gameDurationInSeconds;

    _nextWord();

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());

    _accelSub = accelerometerEvents.listen((event) {
      const threshold = 7.5;

      setState(() {
        if (event.z <= -threshold && isInNeutralPosition) {
          backgroundColor = Colors.red;
          isInNeutralPosition = false;
          _markSkipped();
        } else if (event.z >= threshold && isInNeutralPosition) {
          backgroundColor = Colors.green;
          isInNeutralPosition = false;
          _markCorrect();
        } else if (event.z > -threshold && event.z < threshold) {
          backgroundColor = Colors.white;
          isInNeutralPosition = true;
        }
      });
    });
  }

  void _tick() {
    setState(() {
      remainingSeconds--;
    });

    if (remainingSeconds <= 0) {
      _endGame();
    }
  }

  void _markCorrect() {
    if (currentWord != null) {
      correctWords.add(currentWord!);
      _nextWord();
    }
  }

  void _markSkipped() {
    if (currentWord != null) {
      skippedWords.add(currentWord!);
      _nextWord();
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
    countdownTimer.cancel();
    _accelSub?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameEndScreen(
          correctWords: correctWords,
          skippedWords: skippedWords,
          lastUnmarkedWord: currentWord, // falls vorhanden
        ),
      ),
    );
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    _accelSub?.cancel();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

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
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
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
