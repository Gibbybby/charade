import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../game_settings.dart';
import 'results_screen.dart';

class WordListScreen extends StatefulWidget {
  final List<String> words;
  const WordListScreen({super.key, required this.words});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class WordResult {
  final String word;
  final bool correct;
  WordResult(this.word, this.correct);
}

class _WordListScreenState extends State<WordListScreen> {
  late List<String> _remaining;
  late String _currentWord;
  late Duration _timeLeft;
  Timer? _timer;
  Color _background = const Color(0xFF0F0F1C);
  final List<WordResult> _results = [];

  @override
  void initState() {
    super.initState();
    _remaining = List<String>.from(widget.words);
    _remaining.shuffle(Random());
    _currentWord = _remaining.removeLast();
    _timeLeft = GameSettings.roundDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
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
        builder: (context) => ResultsScreen(results: _results),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
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
        backgroundColor: _background,
        title: Text(_formatTime(_timeLeft)),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          _currentWord,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => _nextWord(false),
                child: const Text('Skip'),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => _nextWord(true),
                child: const Text('Correct'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
