import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'word_list.dart';

class Countdown extends StatefulWidget {
  final List<String> words;

  const Countdown({Key? key, required this.words}) : super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late final List<String> _shuffledWords;
  Timer? _prepTimer;
  Timer? _mainTimer;

  int _prepRemaining = 3; // 3-second prep countdown
  int _remaining = 15; // main countdown seconds
  int _currentIndex = 0;
  bool _prepFinished = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _shuffledWords = List.of(widget.words)..shuffle();

    _prepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prepRemaining > 0) {
        setState(() => _prepRemaining--);
      }
      if (_prepRemaining == 0) {
        timer.cancel();
        setState(() => _prepFinished = true);
        _startMainTimer();
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
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        setState(() => _finished = true);
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _prepTimer?.cancel();
    _mainTimer?.cancel();
    super.dispose();
  }

  void _onTap() {
    if (!_prepFinished || _finished) return;
    setState(() {
      _currentIndex++;
      if (_currentIndex >= _shuffledWords.length) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        _finished = true;
        _mainTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_prepFinished) {
      return Scaffold(
        body: Center(
          child: Text(
            '$_prepRemaining',
            style: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final bool showList = _finished;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: showList ? null : _onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WordList(
                words: _shuffledWords,
                currentIndex: _currentIndex,
                showList: showList,
              ),
            ),
            // Lighter, modern timer display at top-right with Material clock icon
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_remaining',
                        style: const TextStyle(
                          fontSize: 20,
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
