import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/topic.dart';
import '../countdown.dart';
import '../app_state.dart';

class TopicSelectScreen extends StatefulWidget {
  const TopicSelectScreen({Key? key}) : super(key: key);

  @override
  State<TopicSelectScreen> createState() => _TopicSelectScreenState();
}

class _TopicSelectScreenState extends State<TopicSelectScreen> {
  final List<Topic> topics = [
    Topic(imagePath: 'assets/topics/topic_car.png', labelKey: 'car'),
    Topic(
      imagePath: 'assets/topics/topic_geography.png',
      labelKey: 'geography',
    ),
    Topic(imagePath: 'assets/topics/topic_sport.png', labelKey: 'sport'),
    Topic(imagePath: 'assets/topics/topic_party.png', labelKey: 'party'),
    Topic(imagePath: 'assets/topics/topic_film.png', labelKey: 'film'),
    Topic(imagePath: 'assets/topics/topic_serien.png', labelKey: 'series'),
    Topic(imagePath: 'assets/topics/topic_stars.png', labelKey: 'stars'),
    Topic(imagePath: 'assets/topics/topic_animal.png', labelKey: 'animal'),
    Topic(imagePath: 'assets/topics/topic_jobs.png', labelKey: 'jobs'),
    Topic(imagePath: 'assets/topics/topic_music.png', labelKey: 'music'),
  ];

  final Set<int> _selectedIndices = {};

  @override
  void initState() {
    super.initState();
    final selectedTopics =
        Provider.of<AppState>(context, listen: false).selectedTopics;
    for (int i = 0; i < topics.length; i++) {
      if (selectedTopics.any((t) => t.labelKey == topics[i].labelKey)) {
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
    final options = List<int>.generate(23, (i) => (i + 2) * 5);
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
                          Provider.of<AppState>(
                            context,
                            listen: false,
                          ).setTimer(options[index]);
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
    final currentSeconds = Provider.of<AppState>(context).timerSeconds;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      // Hinweis: Wir entfernen das WillPopScope, damit iOS-Swipe-to-Pop wieder funktioniert.
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
              // Header mit adaptivem Back-Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          Platform.isIOS
                              ? const Icon(
                                CupertinoIcons.back,
                                color: Colors.white,
                              )
                              : const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Text(
                        // Falls du 'Topics' lokalisiert haben möchtest, benutze loc.topics o.ä.
                        'Topics',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showTimerPicker(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                              child: Text('$currentSeconds s'),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Grid mit Topics
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

                      final label =
                          {
                            'topicCars': loc.topicCars,
                            'topicGeography': loc.topicGeography,
                            'topicSports': loc.topicSports,
                            'topicParty': loc.topicParty,
                            'topicFilm': loc.topicFilm,
                            'topicSeries': loc.topicSeries,
                            'topicStars': loc.topicStars,
                            'topicAnimals': loc.topicAnimals,
                            'topicJobs': loc.topicJobs,
                            'topicMusic': loc.topicMusic,
                          }[topic.labelKey] ??
                          topic.labelKey;

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
                                Image.asset(topic.imagePath, fit: BoxFit.cover),
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
                                      label,
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
              // Start-Button
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
    );
  }
}
