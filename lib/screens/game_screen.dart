// game_screen.dart
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../controllers/tilt_controller.dart';
import '../widgets/tilt_start_overlay.dart';
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
  List<Map<String, dynamic>> playedWords = [];
  List<bool> lastWordResults = [];

  Timer? countdownTimer;
  StreamSubscription? _accelSub;
  late TiltController tiltController;

  String? currentWord;
  int remainingSeconds = 0;
  Color backgroundColor = Colors.white;

  bool isInNeutralPosition = true;
  bool showTiltToStart = true;
  bool gameEndedByTimeout = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);

    remainingWords = List.of(widget.words)..shuffle(Random());
    remainingSeconds = widget.gameDurationInSeconds;

    tiltController = TiltController(onStart: _startGame);
  }

  void _startGame() {
    setState(() {
      showTiltToStart = false;
      _nextWord();
      countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    });

    _accelSub = accelerometerEvents.listen((event) {
      const threshold = 7.5;

      setState(() {
        if (event.z >= threshold && isInNeutralPosition) {
          backgroundColor = Colors.red;
          isInNeutralPosition = false;
          _markSkipped();
          _vibrateWrong();
        } else if (event.z <= -threshold && isInNeutralPosition) {
          backgroundColor = Colors.green;
          isInNeutralPosition = false;
          _markCorrect();
          _vibrateCorrect();
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
      gameEndedByTimeout = true;
      _endGame();
    }
  }

  void _markCorrect() {
    if (currentWord != null) {
      playedWords.add({'word': currentWord!, 'isCorrect': true});
      lastWordResults.insert(0, true);
      if (lastWordResults.length > 8) lastWordResults.removeLast();
      _nextWord();
    }
  }

  void _markSkipped() {
    if (currentWord != null) {
      playedWords.add({'word': currentWord!, 'isCorrect': false});
      lastWordResults.insert(0, false);
      if (lastWordResults.length > 8) lastWordResults.removeLast();
      _nextWord();
    }
  }

  void _nextWord() {
    if (remainingWords.isEmpty) {
      gameEndedByTimeout = false;
      _endGame();
      return;
    }

    setState(() {
      currentWord = remainingWords.removeAt(0);
    });
  }

  void _endGame() {
    countdownTimer?.cancel();
    _accelSub?.cancel();
    tiltController.dispose();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameEndScreen(
          playedWords: playedWords,
          lastUnmarkedWord: gameEndedByTimeout ? currentWord : null,
        ),
      ),
    );
  }

  void _vibrateCorrect() {
    HapticFeedback.mediumImpact();
  }

  void _vibrateWrong() {
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    if (countdownTimer?.isActive ?? false) {
      countdownTimer?.cancel();
    }
    _accelSub?.cancel();
    tiltController.dispose();

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

  Color _getTimerBoxColor() {
    if (remainingSeconds <= 10) return Colors.red;
    if (remainingSeconds <= 30) return Colors.orange;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: _endGame,
                child: const Icon(Icons.close, size: 32, color: Colors.black),
              ),
            ),
            if (!showTiltToStart)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getTimerBoxColor().withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: 70,
                    child: Center(
                      child: Text(
                        _formatTime(remainingSeconds),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (!showTiltToStart)
              Center(
                child: Text(
                  currentWord ?? '',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: backgroundColor == Colors.white ? Colors.black : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (!showTiltToStart)
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        lastWordResults.length,
                            (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.circle,
                            size: 12,
                            color: lastWordResults[index] ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (showTiltToStart) const TiltStartOverlay(),
          ],
        ),
      ),
    );
  }
}