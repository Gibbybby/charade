import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'countdown.dart';

class Topic {
  final String imagePath;
  final String label;
  final List<String> words;

  Topic({required this.imagePath, required this.label, required this.words});
}

class TopicSelectScreen extends StatefulWidget {
  const TopicSelectScreen({Key? key}) : super(key: key);

  @override
  State<TopicSelectScreen> createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  final Set<int> _selectedIndices = {};
  List<Topic> _topics = [];

  static const Map<String, String> _imageMap = {
    'Autos': 'assets/topics/topic_car.png',
    'Geografie': 'assets/topics/topic_geography.png',
    'Sport': 'assets/topics/topic_sport.png',
    'Party': 'assets/topics/topic_party.png',
    'Film': 'assets/topics/topic_film.png',
    'Serien': 'assets/topics/topic_serien.png',
    'Stars': 'assets/topics/topic_stars.png',
    'Tiere': 'assets/topics/topic_animal.png',
    'Jobs': 'assets/topics/topic_jobs.png',
    'Music': 'assets/topics/topic_music.png',
  };

  @override
  void initState() {
    super.initState();
    _loadTopicsFromJson();
  }

  Future<void> _loadTopicsFromJson() async {
    const langCode = 'de'; // Feste Spracheinstellung
    final jsonString = await rootBundle.loadString(
      'assets/charades_topics_$langCode.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final loaded = <Topic>[];

    jsonMap.forEach((label, list) {
      if (label == 'Drogen' || label == 'Rund um Sex') return;

      final words = List<String>.from(list as List);
      final imagePath = _imageMap[label] ?? 'assets/topics/default.png';
      loaded.add(Topic(imagePath: imagePath, label: label, words: words));
    });

    setState(() {
      _topics = loaded;
    });
  }

  void _onStartPressed() {
    final route =
        Platform.isIOS
            ? CupertinoPageRoute(builder: (_) => const Countdown())
            : MaterialPageRoute(builder: (_) => const Countdown());

    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    final canStart = _selectedIndices.isNotEmpty;

    final content = Column(
      children: [
        if (!Platform.isIOS)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Expanded(
                child: Text(
                  'Themen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Platzhalter für frühere Uhr
            ],
          ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                _topics.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                      children: List.generate(_topics.length, (index) {
                        final topic = _topics[index];
                        final isSelected = _selectedIndices.contains(index);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedIndices.remove(index);
                              } else {
                                _selectedIndices.add(index);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  isSelected
                                      ? Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      )
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                width: double.infinity,
                                child: Text(
                                  topic.label,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child:
                Platform.isIOS
                    ? CupertinoButton(
                      color: Colors.white,
                      disabledColor: Colors.white54,
                      onPressed: canStart ? _onStartPressed : null,
                      child: Text(
                        'Start',
                        style: TextStyle(
                          color: const Color(
                            0xFFFF5F8D,
                          ).withOpacity(canStart ? 1.0 : 0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : FloatingActionButton.extended(
                      onPressed: canStart ? _onStartPressed : null,
                      backgroundColor: canStart ? Colors.white : Colors.white54,
                      label: Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(
                            0xFFFF5F8D,
                          ).withOpacity(canStart ? 1.0 : 0.5),
                        ),
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );

    final decorated = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF5F8D), Color(0xFFFFA726)],
        ),
      ),
      child: SafeArea(child: content),
    );

    return Platform.isIOS
        ? CupertinoTheme(
          data: const CupertinoThemeData(primaryColor: Colors.white),
          child: CupertinoPageScaffold(
            backgroundColor: Colors.transparent,
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Colors.transparent,
              border: null,
              previousPageTitle: '',
              middle: const Text(
                'Themen',
                style: TextStyle(color: Colors.white),
              ),
            ),
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white, fontSize: 16),
              child: decorated,
            ),
          ),
        )
        : Scaffold(
          body: decorated,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
  }
}
