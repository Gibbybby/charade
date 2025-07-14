import 'package:charadex/screens/game_screen.dart';
import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../widgets/category_filter.dart';
import '../widgets/bottom_control_panel.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<String> selectedCategories = {'all'};
  Set<String> selectedTopicIds = {};
  int seconds = 45;

  List<Topic> get filteredTopics {
    if (selectedCategories.contains('all')) return topics;
    return topics.where((t) => selectedCategories.contains(t.category)).toList();
  }

  void toggleCategory(String id) {
    setState(() {
      if (id == 'all') {
        selectedCategories = {'all'};
      } else {
        selectedCategories.remove('all');
        if (selectedCategories.contains(id)) {
          selectedCategories.remove(id);
        } else {
          selectedCategories.add(id);
        }
        if (selectedCategories.isEmpty) {
          selectedCategories = {'all'};
        }
      }
    });
  }

  void toggleTopicSelection(String topicId) {
    setState(() {
      if (selectedTopicIds.contains(topicId)) {
        selectedTopicIds.remove(topicId);
      } else {
        selectedTopicIds.add(topicId);
      }
    });
  }

  void increaseTime() {
    setState(() {
      if (seconds < 300) {
        seconds += 15;
      }
    });
  }

  void decreaseTime() {
    setState(() {
      if (seconds > 15) {
        seconds -= 15;
      }
    });
  }

  void startGame() {
    if (selectedTopicIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte wähle mindestens ein Thema aus.')),
      );
      return;
    }

    final selectedTopics = topics.where((topic) => selectedTopicIds.contains(topic.id)).toList();
    final allWords = selectedTopics.expand((t) => t.words).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          words: allWords,
          gameDurationInSeconds: seconds,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // <-- Weißer Hintergrund
      appBar: AppBar(
        title: const Text('Charade'), // <-- Neuer Titel
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryFilter(
              selectedCategories: selectedCategories,
              onCategoryToggle: toggleCategory,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: filteredTopics.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final topic = filteredTopics[index];
                final isSelected = selectedTopicIds.contains(topic.id);

                return GestureDetector(
                  onTap: () => toggleTopicSelection(topic.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                      border: isSelected
                          ? Border.all(
                        color: Colors.yellow,
                        width: 4,
                      )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
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
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  Colors.black.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                topic.nameKey,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black54,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
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
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomControlPanel(
          seconds: seconds,
          onStartGame: startGame,
          onIncrease: increaseTime,
          onDecrease: decreaseTime,
        ),
      ),
    );
  }
}
