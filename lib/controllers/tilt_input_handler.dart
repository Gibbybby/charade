// tilt_input_handler.dart
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';

class TiltInputHandler {
  final void Function() onTiltUp;
  final void Function() onTiltDown;
  final void Function() onResetNeutral;
  final void Function() onStartGame;
  final bool Function() isInStartPosition;
  final bool Function() isGameStarted;

  bool _isInNeutralPosition = true;
  StreamSubscription? _subscription;

  TiltInputHandler({
    required this.onTiltUp,
    required this.onTiltDown,
    required this.onResetNeutral,
    required this.onStartGame,
    required this.isInStartPosition,
    required this.isGameStarted,
  });

  void startListening() {
    const tiltThreshold = 4.5;
    _subscription = accelerometerEvents.listen((event) {
      if (!isGameStarted()) {
        if (isInStartPosition()) {
          if (event.y.abs() > tiltThreshold || event.x.abs() > tiltThreshold) {
            HapticFeedback.heavyImpact();
            onStartGame();
          }
        }
        return;
      }

      if (!_isInNeutralPosition) {
        if (event.z >= -tiltThreshold && event.z <= tiltThreshold) {
          _isInNeutralPosition = true;
          onResetNeutral();
        }
        return;
      }

      if (event.z <= -tiltThreshold && _isInNeutralPosition) {
        HapticFeedback.vibrate();
        _isInNeutralPosition = false;
        onTiltDown();
      } else if (event.z >= tiltThreshold && _isInNeutralPosition) {
        HapticFeedback.mediumImpact();
        _isInNeutralPosition = false;
        onTiltUp();
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }
}