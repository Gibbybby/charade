import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'countdown.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  bool _hasTiltedDown = false;

  @override
  void initState() {
    super.initState();
    // Landscape erzwingen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Nach Frame-Render Tilt-Listener starten
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListeningTilt();
    });
  }

  void _startListeningTilt() {
    _accelSub = accelerometerEvents.listen((event) async {
      final z = event.z;
      // wenn noch nicht getiltet und Z < –3
      if (!_hasTiltedDown && z < -3) {
        _hasTiltedDown = true;
        // Vibrieren
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 50);
        }
        // „Ding“-Sound
        final player = AudioPlayer();
        await player.setPlayerMode(PlayerMode.lowLatency);
        await player.play(AssetSource('sounds/ding.mp3'));
        // Navigation zum Countdown
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Countdown()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Halte dein iPhone an die Stirn und kippe es nach vorne, um zu starten!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Linke untere Ecke: Tilt phone down for true (grün)
          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_downward, size: 40, color: Colors.green),
                SizedBox(height: 4),
                Text(
                  'Tilt phone down',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  'for true',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Rechte untere Ecke: Tilt phone up for false (rot)
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_upward, size: 40, color: Colors.red),
                SizedBox(height: 4),
                Text(
                  'Tilt phone up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'for false',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
