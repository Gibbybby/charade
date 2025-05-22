import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/topic.dart';
import '../countdown.dart';
import '../app_state.dart';
import '../start_screen.dart';

class TopicSelectScreen extends StatefulWidget {
  const TopicSelectScreen({Key? key}) : super(key: key);

  @override
  State<TopicSelectScreen> createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  final List<Topic> topics = [
    Topic(
      imagePath: 'assets/topics/topic_car.png',
      label: 'Cars',
      words: ['Car1', 'Car2', 'Car3'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_geography.png',
      label: 'Geography',
      words: ['Country1', 'Mountain2', 'Ocean3'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_sport.png',
      label: 'Sports',
      words: ['Football', 'Tennis', 'Basketball'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_party.png',
      label: 'Party',
      words: ['topic_party'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_film.png',
      label: 'Film',
      words: ['topic_film'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_serien.png',
      label: 'Series',
      words: ['topic_serien'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_stars.png',
      label: 'Stars',
      words: ['topic_stars'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_animal.png',
      label: 'Animals',
      words: ['topic_animal'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_jobs.png',
      label: 'Jobs',
      words: ['topic_jobs'],
    ),
    Topic(
      imagePath: 'assets/topics/topic_music.png',
      label: 'Music',
      words: ['topic_music'],
    ),
  ];

  final Set<int> _selectedIndices = {};

  @override
  void initState() {
    super.initState();
    final selectedTopics =
        Provider.of<AppState>(context, listen: false).selectedTopics;
    for (int i = 0; i < topics.length; i++) {
      if (selectedTopics.any((t) => t.label == topics[i].label)) {
        _selectedIndices.add(i);
      }
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _onStartPressed(BuildContext context) {
    final selectedTopics =
        _selectedIndices.map((index) => topics[index]).toList();
    Provider.of<AppState>(
      context,
      listen: false,
    ).setSelectedTopics(selectedTopics);

    final route =
        Platform.isIOS
            ? CupertinoPageRoute(builder: (_) => const Countdown())
            : MaterialPageRoute(builder: (_) => const Countdown());
    Navigator.of(context).push(route);
  }

  void _showTimerPicker(BuildContext context) {
    final currentSeconds =
        Provider.of<AppState>(context, listen: false).timerSeconds;
    // Liste von 10s bis 120s in 5s Schritten
    final options = List<int>.generate(23, (i) => (i + 2) * 5);

    // Finde Index oder setze auf 0
    int initialIndex = options.indexOf(currentSeconds);
    if (initialIndex == -1) initialIndex = 0;
    int selectedIndex = initialIndex;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      onPressed: () {
                        final seconds = options[selectedIndex];
                        Provider.of<AppState>(
                          context,
                          listen: false,
                        ).setTimer(seconds);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Fertig',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: initialIndex,
                      ),
                      itemExtent: 36.0,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      children:
                          options
                              .map(
                                (seconds) =>
                                    Center(child: Text('$seconds Sekunden')),
                              )
                              .toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const CharadePartyHomePage()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        body: Container(
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const CharadePartyHomePage(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Topics',
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
                        onPressed: () => _showTimerPicker(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      itemCount: topics.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) {
                        final topic = topics[index];
                        final isSelected = _selectedIndices.contains(index);

                        return GestureDetector(
                          onTap: () => _toggleSelection(index),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    topic.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.center,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        topic.label,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        Platform.isIOS
                            ? CupertinoButton(
                              color:
                                  _selectedIndices.isNotEmpty
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.2),
                              onPressed:
                                  _selectedIndices.isNotEmpty
                                      ? () => _onStartPressed(context)
                                      : null,
                              child: const Text(
                                'Start',
                                style: TextStyle(
                                  color: Color(0xFFFF5F8D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            : FloatingActionButton.extended(
                              onPressed:
                                  _selectedIndices.isNotEmpty
                                      ? () => _onStartPressed(context)
                                      : null,
                              backgroundColor:
                                  _selectedIndices.isNotEmpty
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.2),
                              label: const Text(
                                'Start',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF5F8D),
                                ),
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
