import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

typedef OnTiltStart = void Function();

class TiltController {
  static const double tiltThreshold = 7.5;
  static const double readyZMin = -10.0;
  static const double readyZMax = -7.0;

  final OnTiltStart onStart;
  final ValueNotifier<bool> isReadyToTilt = ValueNotifier(false);

  late StreamSubscription<AccelerometerEvent> _subscription;
  bool _tiltTriggered = false;

  TiltController({required this.onStart}) {
    _subscription = accelerometerEvents.listen(_handleTilt);
  }

  void _handleTilt(AccelerometerEvent event) {
    final z = event.z;

    if (!_tiltTriggered) {
      // 1. Handy zeigt mit Kamera nach vorne
      if (z >= readyZMin && z <= readyZMax) {
        isReadyToTilt.value = true;
      } else {
        isReadyToTilt.value = false;
        return;
      }

      // 2. Jetzt darf getiltet werden
      if (z >= tiltThreshold || z <= -tiltThreshold) {
        _tiltTriggered = true;
        _vibrate();
        onStart();
      }
    }
  }

  void dispose() {
    _subscription.cancel();
    isReadyToTilt.dispose();
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 150);
    }
  }
}
