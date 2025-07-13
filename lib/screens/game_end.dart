import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameEndScreen extends StatefulWidget {
  const GameEndScreen({super.key});

  @override
  State<GameEndScreen> createState() => _GameEndScreenState();
}

class _GameEndScreenState extends State<GameEndScreen> {
  @override
  void initState() {
    super.initState();

    // Nur Portrait Up erlauben
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    // Alle Orientierungen wieder erlauben
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Spiel beendet!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Zurück zum Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
