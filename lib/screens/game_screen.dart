import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

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
  Color _background = const Color(0xFF0F0F1C);
  final List<WordResult> _results = [];
  static const int _maxDots = 8;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    _remaining = List<String>.from(widget.words);
    _remaining.shuffle(Random());
    _currentWord = _remaining.removeLast();
    _timeLeft = GameSettings.roundDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _formatTime(_timeLeft),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Congratulations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentWord,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
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
