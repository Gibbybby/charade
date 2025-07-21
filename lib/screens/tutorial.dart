import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).t('howToPlay'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _tutorialBox(
            step: 1,
            cardColor: cardColor,
            heading: AppLocalizations.of(context).t('chooseCategory'),
            description:
                AppLocalizations.of(context).t('chooseCategoryDesc'),
          ),
          const SizedBox(height: 16),
          _tutorialBox(
            step: 2,
            cardColor: cardColor,
            heading: AppLocalizations.of(context).t('phoneForehead'),
            description:
                AppLocalizations.of(context).t('phoneForeheadDesc'),
          ),
          const SizedBox(height: 16),
          _tutorialBox(
            step: 3,
            cardColor: cardColor,
            heading: AppLocalizations.of(context).t('tiltControl'),
            description: AppLocalizations.of(context).t('tiltControlDesc'),
            extras: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/tutorial/correct.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Image.asset(
                      'assets/tutorial/incorrect.png',
                      height: 100,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _tutorialBox(
            step: 4,
            cardColor: cardColor,
            heading: AppLocalizations.of(context).t('letsGo'),
            description: AppLocalizations.of(context).t('haveFun'),
          ),
        ],
      ),
    );
  }

  Widget _tutorialBox({
    required int step,
    required String heading,
    required String description,
    required Color cardColor,
    List<Widget> extras = const [],
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber[600],
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                ...extras,
              ],
            ),
          )
        ],
      ),
    );
  }
}
