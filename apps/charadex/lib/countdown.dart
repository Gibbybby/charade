import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'game_screen.dart';

class Countdown extends StatefulWidget {
  const Countdown({Key? key}) : super(key: key);

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  int _count = 3;
  bool _showStartText = false;
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Sofortigen ersten Ton + Anzeige starten
    Future.delayed(Duration.zero, () {
      _playBeep();
      _startCountdown();
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_count > 1) {
        setState(() {
          _count--;
        });
        await _playBeep();
      } else {
        timer.cancel();
        setState(() {
          _count = 0;
          _showStartText = true;
        });
        await _playHighBeep();

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const GameScreen()),
            );
          }
        });
      }
    });
  }

  Future<void> _playBeep() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
  }

  Future<void> _playHighBeep() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('sounds/highbeep.mp3'));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          _showStartText ? loc.start : '$_count',
          style: const TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
