import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartenspiele',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TopicSelectScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Modell für ein Thema mit Bild, Label und 10 passenden Wörtern
class Topic {
  final String imagePath;
  final String label;
  final List<String> words;

  const Topic({
    required this.imagePath,
    required this.label,
    required this.words,
  });
}

class TopicSelectScreen extends StatefulWidget {
  const TopicSelectScreen({Key? key}) : super(key: key);

  @override
  _TopicSelectScreenState createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  final Set<int> _selectedIndices = {};

  final List<Topic> _topics = const [
    Topic(
      imagePath: 'assets/topics/topic_car.png',
      label: 'Autos',
      words: [
        'Motor',
        'Felge',
        'Kotflügel',
        'PS',
        'Lenkrad',
        'Kofferraum',
        'Kupplung',
        'Scheinwerfer',
        'Getriebe',
        'Dach',
      ],
    ),
    Topic(
      imagePath: 'assets/topics/topic_geography.png',
      label: 'Geographie',
      words: [
        'Kontinent',
        'Fluss',
        'Gebirge',
        'Insel',
        'Klima',
        'Atlas',
        'Äquator',
        'Höhenlage',
        'Küste',
        'Wüste',
      ],
    ),
    Topic(
      imagePath: 'assets/topics/topic_sport.png',
      label: 'Sport',
      words: [
        'Ball',
        'Trainer',
        'Mannschaft',
        'Tor',
        'Schiedsrichter',
        'Stadion',
        'Wettkampf',
        'Training',
        'Turnier',
        'Gold',
      ],
    ),
    Topic(
      imagePath: 'assets/topics/topic_film.png',
      label: 'Film',
      words: [
        'Regisseur',
        'Schauspieler',
        'Kamera',
        'Drehbuch',
        'Genre',
        'Premiere',
        'Schnitt',
        'Soundtrack',
        'Set',
        'Plot',
      ],
    ),
    Topic(
      imagePath: 'assets/topics/topic_animal.png',
      label: 'Tiere',
      words: [
        'Säugetier',
        'Vogel',
        'Reptil',
        'Fisch',
        'Insekt',
        'Fell',
        'Gefieder',
        'Revier',
        'Beute',
        'Laich',
      ],
    ),
    Topic(
      imagePath: 'assets/topics/topic_jobs.png',
      label: 'Jobs',
      words: [
        'Arzt',
        'Lehrer',
        'Ingenieur',
        'Friseur',
        'Koch',
        'Mechaniker',
        'Programmierer',
        'Designer',
        'Bäcker',
        'Pilot',
      ],
    ),
    Topic(
      imagePath: 'assets/topics/topic_stars.png',
      label: 'Stars',
      words: [
        'Sänger',
        'Schauspieler',
        'Influencer',
        'Moderator',
        'Athlet',
        'Oscar',
        'Fan',
        'Interview',
        'Autogramm',
        'Tour',
      ],
    ),
  ];

  void _onStartPressed() {
    final selectedWords =
        _selectedIndices
            .map((i) => _topics[i].words)
            .expand((list) => list)
            .toList();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Countdown(words: selectedWords)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fabWidth = MediaQuery.of(context).size.width * 0.9;
    final bool canStart = _selectedIndices.isNotEmpty;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF5F8D), Color(0xFFFFA726)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: ListView(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Themen',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(_topics.length, (index) {
                    final topic = _topics[index];
                    final isSelected = _selectedIndices.contains(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected
                              ? _selectedIndices.remove(index)
                              : _selectedIndices.add(index);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              isSelected
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(topic.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            color: Colors.black26,
                            child: Text(
                              topic.label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: fabWidth, height: 50),
        child: FloatingActionButton.extended(
          onPressed: canStart ? _onStartPressed : null,
          backgroundColor: canStart ? Colors.white : Colors.white54,
          label: Text(
            'Start',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF5F8D).withOpacity(canStart ? 1.0 : 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class Countdown extends StatefulWidget {
  final List<String> words;
  const Countdown({Key? key, required this.words}) : super(key: key);

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> with TickerProviderStateMixin {
  late AnimationController _confettiController;
  final Random _random = Random();
  final List<ConfettiPiece> _confettiPieces = [];
  int _countdown = 3;
  Timer? _timer;
  String? _currentWord;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        _onCountdownComplete();
      }
    });
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    )..repeat();
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
  }

  void _onCountdownComplete() {
    if (widget.words.isNotEmpty) {
      setState(() {
        _currentWord = widget.words[_random.nextInt(widget.words.length)];
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child:
                  _countdown > 0
                      ? Text(
                        '$_countdown',
                        key: ValueKey<int>(_countdown),
                        style: const TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      )
                      : Text(
                        _currentWord ?? '',
                        key: ValueKey<String>(_currentWord ?? ''),
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
            ),
          ),
          if (_countdown > 0)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Text(
                'Kippe↓ richtig • Kippe↑ überspringen',
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
  double x, y, speed, size, swayAmplitude, swaySpeed;
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
