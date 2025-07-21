import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../game_settings.dart';
import 'game_end_screen.dart';
import '../localization.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  final List<String> words;
  const GameScreen({super.key, required this.words});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class WordResult {
  final String word;
  final bool? correct;
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
  bool _showInstructions = GameSettings.startTutorial;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  bool _processingTilt = false;
  bool _tiltCorrect = false;
  bool _readyForTilt = false;
  Color _background = const Color(0xFF0F0F1C);

  Color get _baseBackground => Theme.of(context).scaffoldBackgroundColor;
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
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        _accelSub = accelerometerEvents.listen(_onAccelerometer);
      });
    }
    if (!_showInstructions) {
      _startCountdown();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _background = _baseBackground;
  }

  void _startCountdown() {
    _countdown = 3;
    _countdownDisplay = '$_countdown';
    setState(() {
      _showCountdown = true;
    });
    HapticFeedback.lightImpact();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        HapticFeedback.heavyImpact();
        Future.delayed(const Duration(milliseconds: 100), () {
          HapticFeedback.heavyImpact();
        });
        setState(() {
          _countdownDisplay = AppLocalizations.of(context).t('start');
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() {
            _showCountdown = false;
          });
          _startTimer();
        });
      } else {
        _countdown -= 1;
        setState(() {
          _countdownDisplay = '$_countdown';
        });
        HapticFeedback.lightImpact();
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
      _readyForTilt = false;
    });
    _startCountdown();
  }

  void _onAccelerometer(AccelerometerEvent event) {
    final z = event.z;
    if (_showInstructions) {
      if (!_readyForTilt && z.abs() < 2) {
        _readyForTilt = true;
      }
      if (_readyForTilt && z.abs() > 7) {
        _startGame();
      }
      return;
    }
    if (_showCountdown) return;

    if (!_processingTilt) {
      if (z > 7) {
        _processingTilt = true;
        _tiltCorrect = true;
        setState(() {
          _background = Colors.red;
        });
        HapticFeedback.mediumImpact();
      } else if (z < -7) {
        _processingTilt = true;
        _tiltCorrect = false;
        setState(() {
          _background = Colors.green;
        });
        HapticFeedback.mediumImpact();
      }
    } else {
      if (z.abs() < 3) {
        _processingTilt = false;
        final res = _tiltCorrect;
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
                color: r.correct == null
                    ? Colors.grey
                    : (r.correct! ? Colors.red : Colors.green),
              ),
            ),
          ),
        )
        .toList();
  }

  void _tick(Timer timer) {
    if (_timeLeft.inSeconds <= 1) {
      timer.cancel();
      _endRound(addUnanswered: true);
    } else {
      setState(() {
        _timeLeft -= const Duration(seconds: 1);
      });
    }
  }

  void _nextWord(bool correct) {
    _results.add(WordResult(_currentWord, correct));
    if (_remaining.isEmpty) {
      _endRound(addUnanswered: false);
      return;
    }
    setState(() {
      _background = correct ? Colors.red : Colors.green;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _background = _baseBackground;
        _currentWord = _remaining.removeLast();
      });
    });
  }

  void _endRound({bool addUnanswered = true}) {
    _timer?.cancel();
    if (addUnanswered) {
      _results.add(WordResult(_currentWord, null));
    }
    HapticFeedback.vibrate();
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 8,
              child: GestureDetector(
                onTap: () => _endRound(addUnanswered: true),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
            if (!_showCountdown && !_showInstructions) ...[
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
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                height: double.infinity,
                child: GameSettings.movementsEnabled
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).t('givePhone'),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 24),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Align(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                              ),
                              onPressed: _startGame,
                              child: Text(
                                AppLocalizations.of(context).t('start'),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        AppLocalizations.of(context).t('holdPhone'),
                        style: const TextStyle(color: Colors.white, fontSize: 20),
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
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _nextWord(false);
                    },
                    child: Text(AppLocalizations.of(context).t('skip')),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _nextWord(true);
                    },
                    child: Text(AppLocalizations.of(context).t('correct')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}
