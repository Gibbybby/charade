import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Countdown extends StatefulWidget {
  /// Liste der Wörter, die von der vorherigen Bildschirmübersicht übergeben werden
  final List<String> words;

  const Countdown({Key? key, required this.words}) : super(key: key);

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> with TickerProviderStateMixin {
  late AnimationController _confettiController;
  final Random _random = Random();
  final List<ConfettiPiece> _confettiPieces = [];

  // Countdown state
  int _countdown = 3;
  Timer? _timer;

  // Aktuelles Wort nach Countdown
  String? _currentWord;
  int? _currentIndex;

  // Sensor subscription for tilt detection
  StreamSubscription<AccelerometerEvent>? _accelSub;
  DateTime _lastTilt = DateTime.now();
  static const double _tiltThreshold =
      6.0; // adjust sensitivity: ~9.8 is gravity
  static const int _tiltCooldownMs = 500;

  @override
  void initState() {
    super.initState();
    // Force landscape orientation only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Erzeuge Konfetti-Stücke
    for (int i = 0; i < 20; i++) {
      _confettiPieces.add(
        ConfettiPiece(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.0005 + _random.nextDouble() * 0.0015,
          swayAmplitude: 20 + _random.nextDouble() * 10,
          swaySpeed: 1 + _random.nextDouble() * 2,
          size: 6 + _random.nextDouble() * 8,
          color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
        ),
      );
    }

    // Starte endlose Konfetti-Animation
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    )..repeat();

    // Starte Countdown-Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        _onCountdownComplete();
        // Starte Sensor-Listener, wenn Countdown vorbei ist
        _startTiltListener();
      }
    });
  }

  void _onCountdownComplete() {
    if (widget.words.isNotEmpty) {
      _showNextWord();
    }
  }

  void _showNextWord() {
    if (widget.words.isEmpty) return;
    int nextIndex;
    if (widget.words.length == 1) {
      nextIndex = 0;
    } else {
      do {
        nextIndex = _random.nextInt(widget.words.length);
      } while (_currentIndex != null && nextIndex == _currentIndex);
    }
    setState(() {
      _currentIndex = nextIndex;
      _currentWord = widget.words[nextIndex];
      _countdown = -1; // Deaktiviere Countdown-Zweig
    });
  }

  void _startTiltListener() {
    _accelSub = accelerometerEvents.listen((event) {
      final now = DateTime.now();
      if (now.difference(_lastTilt).inMilliseconds < _tiltCooldownMs) return;

      // In Landscape-Mode hauptsächlich X-Achse nutzen
      if (event.x.abs() > _tiltThreshold) {
        _lastTilt = now;
        _showNextWord();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    _accelSub?.cancel();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_countdown <= 0) {
            _showNextWord();
          }
        },
        child: Stack(
          children: [
            // Hintergrund mit bedingtem Konfetti
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child:
                  _countdown > 0
                      ? AnimatedBuilder(
                        animation: _confettiController,
                        builder: (context, child) {
                          _updateConfetti();
                          return CustomPaint(
                            painter: ConfettiPainter(_confettiPieces),
                          );
                        },
                      )
                      : null,
            ),
            // Zentrum: Countdown oder Wort
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: Text(
                  _countdown > 0 ? '$_countdown' : (_currentWord ?? ''),
                  key: ValueKey<String>(
                    _countdown > 0 ? '$_countdown' : (_currentWord ?? ''),
                  ),
                  style: TextStyle(
                    fontSize: _countdown > 0 ? 120 : 80,
                    fontWeight: FontWeight.bold,
                    color: _countdown > 0 ? Colors.purple : Colors.black87,
                  ),
                ),
              ),
            ),
            // Kurzanleitung unten während Countdown
            if (_countdown > 0)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Text(
                  'Tippe für nächstes Wort • Kippe↓ richtig • Kippe↑ überspringen',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _updateConfetti() {
    for (var piece in _confettiPieces) {
      piece.y += piece.speed;
      if (piece.y > 1.2) {
        piece.y = -0.1;
        piece.x = _random.nextDouble();
      }
    }
  }
}

class ConfettiPiece {
  double x;
  double y;
  double speed;
  double size;
  double swayAmplitude;
  double swaySpeed;
  Color color;

  ConfettiPiece({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.swayAmplitude,
    required this.swaySpeed,
    required this.color,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> confettiPieces;

  ConfettiPainter(this.confettiPieces);

  @override
  void paint(Canvas canvas, Size size) {
    final double time = DateTime.now().millisecondsSinceEpoch / 1000.0;
    for (var piece in confettiPieces) {
      final paint = Paint()..color = piece.color;
      double swayOffset = piece.swayAmplitude * sin(time * piece.swaySpeed);
      double dx = piece.x * size.width + swayOffset;
      double dy = piece.y * size.height;
      canvas.drawCircle(Offset(dx, dy), piece.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
