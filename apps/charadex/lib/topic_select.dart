import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charadex/app_state.dart';
import 'package:charadex/translations.dart';
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
  int _timerLength = 60;
  List<Topic> _topics = [];

  static const Map<String, String> _imageMap = {
    'Autos': 'assets/topics/topic_car.png',
    'Geografie': 'assets/topics/topic_geography.png',
    'Sport': 'assets/topics/topic_sport.png',
    'Rund um Sex': 'assets/topics/topic_sex.png',
    'Drogen': 'assets/topics/topic_drugs.png',
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
    _loadSavedTimer();
  }

  Future<void> _loadTopicsFromJson() async {
    final langCode = AppState.getLanguageCode();
    final jsonString = await rootBundle.loadString(
      'assets/charades_topics_$langCode.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final loaded = <Topic>[];

    jsonMap.forEach((label, list) {
      final words = List<String>.from(list as List);
      final imagePath = _imageMap[label] ?? 'assets/topics/default.png';
      final translatedLabel = Translations.topicLabel(label);
      loaded.add(
        Topic(imagePath: imagePath, label: translatedLabel, words: words),
      );
    });

    setState(() {
      _topics = loaded;
    });
  }

  Future<void> _loadSavedTimer() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _timerLength = prefs.getInt('timer_length') ?? 60;
    });
  }

  Future<void> _saveTimer(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timer_length', value);
  }

  void _showTimerPicker() {
    if (Platform.isIOS) {
      int selected = _timerLength;

      showCupertinoModalPopup(
        context: context,
        builder:
            (_) => Container(
              height: 300,
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: Column(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: selected - 10,
                      ),
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        selected = index + 10;
                      },
                      children: List<Widget>.generate(111, (int index) {
                        final seconds = index + 10;
                        return Center(child: Text('$seconds s'));
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CupertinoButton(
                      child: Text(Translations.t('ok')),
                      onPressed: () {
                        setState(() => _timerLength = selected);
                        _saveTimer(selected);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
      );
    } else {
      double temp = _timerLength.toDouble();
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(Translations.t('timer_title')),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Translations.t(
                        'seconds',
                        params: {'value': temp.toInt().toString()},
                      ),
                    ),
                    Slider(
                      min: 10,
                      max: 120,
                      value: temp,
                      divisions: 110,
                      label: '${temp.toInt()}',
                      onChanged: (val) => setState(() => temp = val),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(Translations.t('cancel')),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _timerLength = temp.toInt());
                      _saveTimer(temp.toInt());
                      Navigator.pop(context);
                    },
                    child: Text(Translations.t('ok')),
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
        _selectedIndices.map((i) => _topics[i].words).expand((w) => w).toList();

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
              Expanded(
                child: Text(
                  Translations.t('topics'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                        Translations.t('start'),
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
                        Translations.t('start'),
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
              middle: Text(
                Translations.t('topics'),
                style: const TextStyle(color: Colors.white),
              ),
              trailing: GestureDetector(
                onTap: _showTimerPicker,
                child: const Icon(CupertinoIcons.timer, color: Colors.white),
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
