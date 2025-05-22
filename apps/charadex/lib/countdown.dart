import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_screen.dart'; // <--- WICHTIG: Importiere GameScreen

class Countdown extends StatefulWidget {
  const Countdown({Key? key}) : super(key: key);

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  int _count = 3;
  bool _showStartText = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count > 1) {
        setState(() => _count--);
      } else {
        timer.cancel();
        setState(() {
          _count = 0;
          _showStartText = true;
        });

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);

            // ✅ Hier GameScreen starten
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const GameScreen()),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          _showStartText ? 'START' : '$_count',
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
