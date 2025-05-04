// lib/countdown.dart

import 'dart:async';
import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final List<String> words;

  const Countdown({Key? key, required this.words}) : super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late final List<String> _shuffledWords;
  late final Timer _timer;

  int _remaining = 15; // Sekunden verbleibend
  int _currentIndex = 0; // Index des aktuell angezeigten Wortes
  bool _finished =
      false; // true, sobald Timer abgelaufen oder alle Wörter gezeigt

  @override
  void initState() {
    super.initState();
    // Wörter mischen
    _shuffledWords = List.of(widget.words)..shuffle();

    // 15-Sekunden-Timer starten
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining > 0) {
        setState(() => _remaining--);
      }
      if (_remaining == 0) {
        timer.cancel();
        setState(() => _finished = true);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTap() {
    if (_finished) return;

    setState(() {
      _currentIndex++;
      // Wenn wir über das letzte Wort hinaus sind, beenden
      if (_currentIndex >= _shuffledWords.length) {
        _finished = true;
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showList = _finished;
    // Anzahl der anzuzeigenden Wörter in der Liste:
    // wenn alle Wörter durch, dann die gesamte Länge,
    // sonst nur die bisher gezeigten (Index + 1).
    final int listCount =
        _currentIndex >= _shuffledWords.length
            ? _shuffledWords.length
            : _currentIndex + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown'),
        backgroundColor: const Color(0xFFFF5F8D),
        actions: [
          // Timer-Anzeige oben rechts
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '$_remaining',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: showList ? null : _onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              showList
                  // LISTE: nur der bereits angezeigten Wörter
                  ? ListView.builder(
                    itemCount: listCount,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orangeAccent,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            _shuffledWords[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  )
                  // VOLL-BILD: aktuelles Wort
                  : Center(
                    child: Text(
                      _shuffledWords[_currentIndex],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
