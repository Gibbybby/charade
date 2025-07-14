// game_screen.dart
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:charadex/controllers/tilt_input_handler.dart';
import 'package:charadex/widgets/tilt_start_overlay.dart';
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
  List<Map<String, dynamic>> playedWords = [];
  List<bool> lastWordResults = [];

  Timer? countdownTimer;
  String? currentWord;
  int remainingSeconds = 0;
  Color backgroundColor = Colors.white;

  bool showTiltToStart = true;
  bool gameEndedByTimeout = true;

  late TiltInputHandler tiltHandler;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);

    remainingWords = List.of(widget.words)..shuffle(Random());
    remainingSeconds = widget.gameDurationInSeconds;

    tiltHandler = TiltInputHandler(
      onTiltUp: _handleCorrect,
      onTiltDown: _handleSkip,
      onResetNeutral: () {
        setState(() => backgroundColor = Colors.white);
      },
      onStartGame: () {
        setState(() {
          showTiltToStart = false;
          _nextWord();
          countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
        });
      },
      isInStartPosition: _isInStartTiltPosition,
      isGameStarted: () => !showTiltToStart,
    );

    tiltHandler.startListening();
  }

  bool _isInStartTiltPosition() {
    // Annahme: idealerweise z > 7.0 (leicht schräg zur Wand)
    return true; // Kann hier ggf. präziser gemacht werden
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

  void _handleCorrect() {
    setState(() {
      backgroundColor = Colors.green;
      _markCorrect();
    });
  }

  void _handleSkip() {
    setState(() {
      backgroundColor = Colors.red;
      _markSkipped();
    });
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
    tiltHandler.stopListening();

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

  @override
  void dispose() {
    countdownTimer?.cancel();
    tiltHandler.stopListening();

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

  Color _timerBoxColor() {
    if (remainingSeconds <= 10) {
      return Colors.red;
    } else if (remainingSeconds <= 30) {
      return Colors.orange;
    } else {
      return Colors.black.withOpacity(0.7);
    }
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
                    color: _timerBoxColor(),
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
