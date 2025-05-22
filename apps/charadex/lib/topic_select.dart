import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
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
  ];

  final Set<int> _selectedIndices = {};

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

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => Navigator.of(context).pop(),
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
                    const SizedBox(width: 48),
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
    );
  }
}
