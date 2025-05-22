import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_state.dart';
import 'topic_select.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({Key? key}) : super(key: key);

  void _playFinishSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('sounds/finish.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    // Play finish sound once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playFinishSound();
    });

    final appState = Provider.of<AppState>(context, listen: false);
    final words = appState.words;
    final answers = appState.answers;

    final int correctCount = answers.where((a) => a).length;
    final int wrongCount = answers.length - correctCount;

    final loc = AppLocalizations.of(context)!;

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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    'assets/images/round_end.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  loc.goodJob,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  loc.results(correctCount, wrongCount),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      final correct = answers[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Center(
                          child: Text(
                            word,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: correct ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        Platform.isIOS
                            ? CupertinoButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TopicSelectScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                loc.backToSelection,
                                style: const TextStyle(
                                  color: Color(0xFFFF5F8D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            : FloatingActionButton.extended(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TopicSelectScreen(),
                                  ),
                                );
                              },
                              backgroundColor: Colors.white,
                              label: Text(
                                loc.backToSelection,
                                style: const TextStyle(
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
