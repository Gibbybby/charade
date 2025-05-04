import 'package:flutter/material.dart';

class WordList extends StatelessWidget {
  final List<String> words;
  final int currentIndex;
  final bool showList;

  const WordList({
    Key? key,
    required this.words,
    required this.currentIndex,
    required this.showList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      child:
          showList
              ? ListView.builder(
                padding: const EdgeInsets.only(top: 32),
                itemCount:
                    (currentIndex >= words.length
                        ? words.length
                        : currentIndex + 1) +
                    1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 160,
                            child: Image.asset(
                              'assets/round_end.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '🎉 Gut gemacht!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // Thema wechseln
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Thema'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // Nochmal
                                      },
                                      icon: const Icon(Icons.replay),
                                      label: const Text('Nochmal'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final wordIndex = index - 1;
                  return Card(
                    color: Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      child: Center(
                        child: Text(
                          words[wordIndex],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
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
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
    );

    // Nur Gradient-Hintergrund, wenn showList aktiv ist
    return showList
        ? Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF5F8D), Color(0xFFFFA726)],
            ),
          ),
          child: content,
        )
        : content;
  }
}
