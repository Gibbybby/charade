import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

import '../app_state.dart';
import 'game_over.dart';
import 'topic_select.dart';

enum TiltState { none, up, down }

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  Timer? _timer;
  int _secondsRemaining = 0;
  TiltState _tiltState = TiltState.none;
  TiltState _lastTiltPlayed = TiltState.none;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      final topics = appState.selectedTopics;
      final allWords = topics.expand((t) => t.words).toList();
      appState.setWords(allWords);

      _secondsRemaining = appState.timerSeconds;
      _startTimer();
      _startListeningTilt();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tiltState == TiltState.none) {
        if (_secondsRemaining > 0) {
          setState(() {
            _secondsRemaining--;
          });
        } else {
          _goToGameOver();
        }
      }
    });
  }

  void _startListeningTilt() {
    _accelSub = accelerometerEvents.listen((event) {
      final z = event.z;

      if (_tiltState == TiltState.none) {
        if (z > 7) {
          _onTilt(TiltState.up, false);
        } else if (z < -7) {
          _onTilt(TiltState.down, true);
        }
      } else {
        if (z.abs() < 2) {
          _onReturnToCenter();
        }
      }
    });
  }

  void _onTilt(TiltState state, bool correct) async {
    setState(() => _tiltState = state);
    final appState = Provider.of<AppState>(context, listen: false);
    appState.recordAnswer(correct);

    if (_lastTiltPlayed != state) {
      _lastTiltPlayed = state;

      // Vibration
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 50);
      }

      // Sound
      final soundPath =
          correct ? 'assets/sounds/ding.mp3' : 'assets/sounds/buzz.mp3';
      await _audioPlayer.play(AssetSource(soundPath));
    }
  }

  void _onReturnToCenter() {
    setState(() => _tiltState = TiltState.none);
    final appState = Provider.of<AppState>(context, listen: false);
    appState.nextWord();
  }

  Future<void> _goToGameOver() async {
    _timer?.cancel();
    _accelSub?.cancel();
    await _audioPlayer.play(AssetSource('assets/sounds/finish.mp3'));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const GameOverScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
            transitionsBuilder: (_, __, ___, child) => child,
          ),
        );
      }
    });
  }

  void _exitGame() {
    _timer?.cancel();
    _accelSub?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TopicSelectScreen()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _accelSub?.cancel();
    _audioPlayer.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentWord = appState.currentWord;
    final answers = appState.answers;

    Color background;
    switch (_tiltState) {
      case TiltState.up:
        background = Colors.red;
        break;
      case TiltState.down:
        background = Colors.green;
        break;
      default:
        background = Colors.black;
    }

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            // X-Button oben links
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTap: _exitGame,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),

            // Timer oben zentriert
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '$_secondsRemaining',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Wort zentriert
            Center(
              child: Text(
                currentWord,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Punkteanzeige unten
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        answers.takeLast(10).map((correct) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: correct ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }).toList(),
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

extension TakeLast<T> on List<T> {
  Iterable<T> takeLast(int n) => length <= n ? this : skip(length - n);
}
