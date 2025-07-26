import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

typedef MotionStartCallback = void Function();
typedef MotionResultCallback = void Function(bool correct);
/// Handles accelerometer based controls for the game.
class PhoneMotion {
  PhoneMotion({
    required this.onStartGame,
    required this.onResult,
    required this.onBackground,
    this.showInstructions = false,
    this.showCountdown = false,
  });

  bool showInstructions;
  bool showCountdown;
  final MotionStartCallback onStartGame;
  final MotionResultCallback onResult;
  final void Function(Color) onBackground;

  StreamSubscription<AccelerometerEvent>? _sub;
  bool _processingTilt = false;
  bool _tiltCorrect = false;
  bool _readyForTilt = false;

  void init() {
    _sub = accelerometerEvents.listen(_onEvent);
  }

  void dispose() {
    _sub?.cancel();
  }

  void resetTiltReady() {
    _readyForTilt = false;
  }

  void _onEvent(AccelerometerEvent event) {
    final z = event.z;
    if (showInstructions) {
      if (!_readyForTilt && z.abs() < 2) {
        _readyForTilt = true;
      }
      if (_readyForTilt && z.abs() > 7) {
        onStartGame();
      }
      return;
    }
    if (showCountdown) return;

    if (!_processingTilt) {
      if (z > 7) {
        _processingTilt = true;
        _tiltCorrect = false;
        onBackground(Colors.red);
        HapticFeedback.mediumImpact();
      } else if (z < -7) {
        _processingTilt = true;
        _tiltCorrect = true;
        onBackground(Colors.green);
        HapticFeedback.mediumImpact();
      }
    } else {
      if (z.abs() < 3) {
        _processingTilt = false;
        onResult(_tiltCorrect);
      }
    }
  }
}
