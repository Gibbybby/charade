import 'package:flutter/material.dart';
import 'app_state.dart';
import 'translations.dart';

class WordList extends StatelessWidget {
  final List<String> words;
  final int currentIndex;
  final bool showList;
  final List<Color?> markedColors;

  const WordList({
    Key? key,
    required this.words,
    required this.currentIndex,
    required this.showList,
    required this.markedColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient:
              showList
                  ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFF5F8D), Color(0xFFFFA726)],
                  )
                  : null,
          color: showList ? null : Colors.white,
        ),
        child: SafeArea(
          child:
              showList
                  ? ListView.builder(
                    padding: const EdgeInsets.only(top: 24),
                    itemCount: (currentIndex + 1).clamp(0, words.length) + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Statistik: letzte unbewertete Antwort zählt als falsch
                        int correct = 0;
                        int incorrect = 0;
                        for (
                          int i = 0;
                          i <= currentIndex && i < markedColors.length;
                          i++
                        ) {
                          final color = markedColors[i];
                          if (color == Colors.green) {
                            correct++;
                          } else if (color == Colors.red ||
                              (color == null && i == currentIndex)) {
                            incorrect++;
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: SizedBox(
                                  height: 120,
                                  child: Image.asset(
                                    'assets/round_end.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      Translations.t('well_done'),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FilledButton.icon(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          label: Text(
                                            Translations.t('back_to_menu'),
                                          ),
                                          icon: const Icon(Icons.arrow_back),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                Translations.t(
                                  'correct_incorrect',
                                  params: {
                                    'correct': correct.toString(),
                                    'incorrect': incorrect.toString(),
                                  },
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final wordIndex = index - 1;
                      Color color;
                      if (markedColors.length > wordIndex) {
                        color =
                            markedColors[wordIndex] ??
                            (wordIndex == currentIndex
                                ? Colors.red
                                : Colors.black);
                      } else {
                        color =
                            wordIndex == currentIndex
                                ? Colors.red
                                : Colors.black;
                      }

                      return Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          child: Center(
                            child: Text(
                              words[wordIndex],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                  : Center(
                    child: Text(
                      words[currentIndex],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
