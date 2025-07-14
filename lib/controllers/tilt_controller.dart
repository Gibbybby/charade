// tilt_controller.dart
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class TiltController {
  final VoidCallback onStart;
  StreamSubscription? _subscription;
  bool _started = false;
  bool _readyToStart = false;

  TiltController({required this.onStart}) {
    _subscription = accelerometerEvents.listen(_handleEvent);
  }

  void _handleEvent(AccelerometerEvent event) {
    const wallThresholdMin = 8.0; // Etwas Spielraum
    const wallThresholdMax = 11.0;
    const tiltThreshold = 6.0; // Leichtes Kippen erlaubt

    if (_started) return;

    // Ist Gerät ungefähr in "Display zur Wand" Position?
    if (event.z >= wallThresholdMin && event.z <= wallThresholdMax) {
      _readyToStart = true;
    }

    if (_readyToStart) {
      final isTilted = event.y.abs() > tiltThreshold || event.x.abs() > tiltThreshold;
      if (isTilted) {
        _started = true;
        HapticFeedback.heavyImpact();
        onStart();
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
