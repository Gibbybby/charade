import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../game_settings.dart';
import 'game_end_screen.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  final List<String> words;
  const GameScreen({super.key, required this.words});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class WordResult {
  final String word;
  final bool correct;
  WordResult(this.word, this.correct);
}

class _GameScreenState extends State<GameScreen> {
  late List<String> _remaining;
  late String _currentWord;
  late Duration _timeLeft;
  Timer? _timer;
  Timer? _countdownTimer;
  int _countdown = 3;
  String _countdownDisplay = '3';
  bool _showCountdown = false;
  bool _showInstructions = true;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  bool _processingTilt = false;
  bool _tiltCorrect = false;
  Color _background = const Color(0xFF0F0F1C);
  final List<WordResult> _results = [];
  static const int _maxDots = 8;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    _remaining = List<String>.from(widget.words);
    _remaining.shuffle(Random());
    _currentWord = _remaining.removeLast();
    _timeLeft = GameSettings.roundDuration;
    if (!GameSettings.movementsEnabled) {
      _accelSub = accelerometerEvents.listen(_onAccelerometer);
    }
  }

  void _startCountdown() {
    _countdown = 3;
    _countdownDisplay = '$_countdown';
    setState(() {
      _showCountdown = true;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        setState(() {
          _countdownDisplay = 'Start';
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() {
            _showCountdown = false;
          });
          _startTimer();
        });
      } else {
        setState(() {
          _countdownDisplay = '$_countdown';
          _countdown -= 1;
        });
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _startGame() {
    if (!_showInstructions) return;
    setState(() {
      _showInstructions = false;
    });
    _startCountdown();
  }

  void _onAccelerometer(AccelerometerEvent event) {
    final y = event.y;
    if (_showInstructions) {
      if (y.abs() > 7) {
        _startGame();
      }
      return;
    }
    if (_showCountdown) return;

    if (!_processingTilt) {
      if (y > 7) {
        _processingTilt = true;
        _tiltCorrect = true;
        _timer?.cancel();
        setState(() {
          _background = Colors.green;
        });
      } else if (y < -7) {
        _processingTilt = true;
        _tiltCorrect = false;
        _timer?.cancel();
        setState(() {
          _background = Colors.red;
        });
      }
    } else {
      if (y.abs() < 3) {
        _processingTilt = false;
        final res = _tiltCorrect;
        _startTimer();
        _nextWord(res);
      }
    }
  }

  List<Widget> _buildDots() {
    final items = _results.reversed.take(_maxDots).toList().reversed;
    return items
        .map(
          (r) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.circle,
                size: 10,
                color: r.correct ? Colors.green : Colors.red,
              ),
            ),
          ),
        )
        .toList();
  }

  void _tick(Timer timer) {
    if (_timeLeft.inSeconds <= 1) {
      timer.cancel();
      _endRound();
    } else {
      setState(() {
        _timeLeft -= const Duration(seconds: 1);
      });
    }
  }

  void _nextWord(bool correct) {
    _results.add(WordResult(_currentWord, correct));
    if (_remaining.isEmpty) {
      _endRound();
      return;
    }
    setState(() {
      _background = correct ? Colors.green : Colors.red;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _background = const Color(0xFF0F0F1C);
        _currentWord = _remaining.removeLast();
      });
    });
  }

  void _endRound() {
    _timer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameEndScreen(results: _results),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    _accelSub?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Stack(
          children: [
            if (!_showCountdown) ...[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _formatTime(_timeLeft),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  _currentWord,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (_showCountdown)
              Center(
                child: Text(
                  _countdownDisplay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (_showInstructions)
              Container(
                color: Colors.black87,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: GameSettings.movementsEnabled
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Give the phone to another person who marks the words for you.',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _startGame,
                            child: const Text('Start'),
                          )
                        ],
                      )
                    : const Text(
                        'Hold the phone to your forehead. Tilt up to skip and tilt down to mark correct. Tilt up or down to start!',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _showCountdown || _showInstructions || !GameSettings.movementsEnabled
          ? null
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
            if (_results.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildDots(),
                ),
              ),
            if (_results.isNotEmpty) const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _nextWord(false),
                    child: const Text('Skip'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _nextWord(true),
                    child: const Text('Correct'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
