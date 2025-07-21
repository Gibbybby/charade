import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';
import '../localization.dart';

import 'game_screen.dart';

class GameEndScreen extends StatefulWidget {
  final List<WordResult> results;
  const GameEndScreen({super.key, required this.results});

  @override
  State<GameEndScreen> createState() => _GameEndScreenState();
}

class _GameEndScreenState extends State<GameEndScreen> {
  @override
  void initState() {
    super.initState();
    _vibrate();
    _checkReviewPrompt();
  }

  Future<void> _vibrate() async {
    for (int i = 0; i < 3; i++) {
      HapticFeedback.vibrate();
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> _checkReviewPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('game_end_count') ?? 0;
    count += 1;
    await prefs.setInt('game_end_count', count);

    final reviewLater = prefs.getBool('review_later') ?? false;
    final reviewDone = prefs.getBool('review_done') ?? false;

    if (reviewDone) return;

    if ((!reviewLater && count == 4) || (reviewLater && count == 24)) {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).t('enjoyApp')),
            content: Text(AppLocalizations.of(context).t('ratePrompt')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).t('later')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context).t('rate')),
              ),
            ],
          ),
        );
        if (result == true) {
          inAppReview.requestReview();
          await prefs.setBool('review_done', true);
        } else {
          if (!reviewLater) {
            await prefs.setBool('review_later', true);
          } else {
            await prefs.setBool('review_done', true);
          }
        }
      }
    }
  }

  int get _correctCount =>
      widget.results.where((r) => r.correct == true).length;

  int get _skippedCount =>
      widget.results.where((r) => r.correct != true).length;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).t('congratulations'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.results.length,
              itemBuilder: (context, index) {
                final res = widget.results[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      res.word,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: res.correct == null
                            ? Colors.grey
                            : (res.correct! ? Colors.red : Colors.green),
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .t('correctCount', params: {'count': '$_correctCount'}),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(width: 24),
                Text(
                  AppLocalizations.of(context)
                      .t('skippedCount', params: {'count': '$_skippedCount'}),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context).t('backToMenu'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
