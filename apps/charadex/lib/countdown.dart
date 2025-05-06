// countdown.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'word_list.dart';

class Countdown extends StatefulWidget {
  final List<String> words;
  const Countdown({Key? key, required this.words}) : super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late final List<String> _shuffledWords;
  late List<Color?> _markedColors;

  Timer? _prepTimer;
  Timer? _mainTimer;
  Timer? _sensorTimer;

  int _prepRemaining = 3;
  int _remaining = 10;
  int _currentIndex = 0;
  bool _prepFinished = false;
  bool _finished = false;
  bool _tiltCooldown = false;

  double _lastZ = 0;
  Color? _overlayColor;

  @override
  void initState() {
    super.initState();

    // sicherheitshalber Querformat
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _shuffledWords = List.of(widget.words)..shuffle();
    _markedColors = List.filled(_shuffledWords.length, null);

    // Vorbereitungscountdown 3…1
    _prepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prepRemaining > 1) {
        setState(() => _prepRemaining--);
      } else {
        timer.cancel();
        setState(() {
          _prepRemaining = 0;
          _prepFinished = true;
        });
        _startMainTimer();
      }
    });

    // Sensor-Listener
    accelerometerEvents.listen((event) {
      _lastZ = event.z;
    });

    // Alle 200 ms auf Tilt prüfen
    _sensorTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_finished || _tiltCooldown) return;
      if (_lastZ < -7) {
        _handleTilt(Colors.red);
      } else if (_lastZ > 7) {
        _handleTilt(Colors.green);
      }
    });
  }

  void _startMainTimer() {
    _mainTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining > 0) {
        setState(() => _remaining--);
      }
      if (_remaining == 0) {
        timer.cancel();
        setState(() => _finished = true);
      }
    });
  }

  void _handleTilt(Color color) {
    if (!_prepFinished || _finished || _tiltCooldown) return;

    setState(() {
      _overlayColor = color;
      _markedColors[_currentIndex] = color;
      _currentIndex++;
      if (_currentIndex >= _shuffledWords.length) {
        _finished = true;
        _mainTimer?.cancel();
      }
    });

    _tiltCooldown = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _overlayColor = null;
          _tiltCooldown = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _prepTimer?.cancel();
    _mainTimer?.cancel();
    _sensorTimer?.cancel();
    // Portrait wieder erlauben, wenn du möchtest:
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _onTap() {
    if (!_prepFinished || _finished) return;
    setState(() {
      _currentIndex++;
      if (_currentIndex >= _shuffledWords.length) {
        _finished = true;
        _mainTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_prepFinished) {
      // Vorbereitungsbildschirm
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            '$_prepRemaining',
            style: const TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    final showList = _finished;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: showList ? null : _onTap,
        child: Stack(
          children: [
            WordList(
              words: _shuffledWords,
              currentIndex: _currentIndex,
              showList: showList,
              markedColors: _markedColors,
            ),
            if (!showList && _overlayColor != null)
              Positioned.fill(child: Container(color: _overlayColor)),
            if (!showList)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_remaining',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
