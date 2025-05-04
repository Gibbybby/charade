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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 150,
                                child: Image.asset(
                                  'assets/round_end.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Gut gemacht',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Thema wechseln Aktion
                                          },
                                          child: const Text('Thema wechseln'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Nochmal Aktion
                                          },
                                          child: const Text('Nochmal'),
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

                      final int wordIndex = index - 1;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 16,
                          ),
                          title: Center(
                            child: Text(
                              words[wordIndex],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
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
                        color: Colors.white,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
