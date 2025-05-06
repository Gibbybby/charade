import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'countdown.dart';

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
  State<TopicSelectScreen> createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  final Set<int> _selectedIndices = {};
  int _timerLength = 10;

  static const List<Topic> _topics = [
    Topic(
      imagePath: 'assets/topics/topic_car.png',
      label: 'Autos',
      words: ['Auto1', 'Auto2', 'Auto3', 'Auto4', 'Auto5'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_geography.png',
      label: 'Geografie',
      words: [
        'Geografie1',
        'Geografie2',
        'Geografie3',
        'Geografie4',
        'Geografie5',
      ],
    ),
    Topic(
      imagePath: 'assets/topics/topic_sport.png',
      label: 'Sport',
      words: ['Sport1', 'Sport2', 'Sport3', 'Sport4', 'Sport5'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_film.png',
      label: 'Film',
      words: ['Film1', 'Film2', 'Film3', 'Film4', 'Film5'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_animal.png',
      label: 'Tiere',
      words: ['Tier1', 'Tier2', 'Tier3', 'Tier4', 'Tier5'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_jobs.png',
      label: 'Jobs',
      words: ['Job1', 'Job2', 'Job3', 'Job4', 'Job5'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_stars.png',
      label: 'Stars',
      words: ['Star1', 'Star2', 'Star3', 'Star4', 'Star5'],
    ),
  ];

  void _showTimerPicker() {
    double temp = _timerLength.toDouble();

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder:
            (_) => CupertinoActionSheet(
              title: const Text('Timer einstellen'),
              message: Column(
                children: [
                  Text('${temp.toInt()} Sekunden'),
                  CupertinoSlider(
                    min: 10,
                    max: 120,
                    value: temp,
                    onChanged: (val) {
                      setState(() => temp = val);
                    },
                  ),
                ],
              ),
              actions: [
                CupertinoActionSheetAction(
                  child: const Text('OK'),
                  onPressed: () {
                    setState(() => _timerLength = temp.toInt());
                    Navigator.pop(context);
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Abbrechen'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Timer einstellen'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${temp.toInt()} Sekunden'),
                    Slider(
                      min: 10,
                      max: 120,
                      divisions: 110,
                      value: temp,
                      label: '${temp.toInt()}',
                      onChanged: (val) {
                        setState(() => temp = val);
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Abbrechen'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _timerLength = temp.toInt();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  void _onStartPressed() {
    final selectedWords =
        _selectedIndices.expand((i) => _topics[i].words).toList();

    final route =
        Platform.isIOS
            ? CupertinoPageRoute(
              builder:
                  (_) => Countdown(
                    words: selectedWords,
                    initialTimer: _timerLength,
                  ),
            )
            : MaterialPageRoute(
              builder:
                  (_) => Countdown(
                    words: selectedWords,
                    initialTimer: _timerLength,
                  ),
            );

    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    final bool canStart = _selectedIndices.isNotEmpty;

    final body = Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF5F8D), Color(0xFFFFA726)],
        ),
      ),
      child: SafeArea(
        child: Column(
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
                  IconButton(
                    icon: const Icon(Icons.timer, color: Colors.white),
                    onPressed: _showTimerPicker,
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
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
                            color: Colors.black.withOpacity(0.4),
                            padding: const EdgeInsets.symmetric(vertical: 6),
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
                        ? CupertinoButton.filled(
                          onPressed: canStart ? _onStartPressed : null,
                          child: const Text('Start'),
                        )
                        : FloatingActionButton.extended(
                          onPressed: canStart ? _onStartPressed : null,
                          backgroundColor:
                              canStart ? Colors.white : Colors.white54,
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
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Themen'),
            trailing: GestureDetector(
              onTap: _showTimerPicker,
              child: const Icon(CupertinoIcons.timer),
            ),
          ),
          child: body,
        )
        : Scaffold(
          body: body,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
  }
}
