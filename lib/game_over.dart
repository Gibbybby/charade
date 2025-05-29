import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_state.dart';
import 'topic_select.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({Key? key}) : super(key: key);

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  late final AudioPlayer _player;
  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _playFinishSoundOnce();
  }

  void _playFinishSoundOnce() {
    if (!_hasPlayed) {
      _hasPlayed = true;
      _player.play(AssetSource('sounds/finish.mp3'));
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _onBackPressed() {
    // Sound stoppen
    _player.stop();
    // zurück zur Auswahl
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TopicSelectScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    fontSize: 50,
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
                              onPressed: _onBackPressed,
                              child: Text(
                                loc.backToSelection,
                                style: const TextStyle(
                                  color: Color(0xFFFF5F8D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            : FloatingActionButton.extended(
                              onPressed: _onBackPressed,
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
