import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTutorialPage extends StatelessWidget {
  const MainTutorialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fest codierte Texte und Icons
    final backgroundColor = const Color(0xFFF5F5F7);
    final textColor = Colors.black87;
    final iconColor = const Color(0xFF1A63A1);

    Widget buildStep(IconData icon, String title, String description) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      color: textColor.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
        centerTitle: true,
        leading:
            Platform.isIOS
                ? IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: iconColor),
                  onPressed: () => Navigator.of(context).pop(),
                )
                : null,
        title: Text(
          'Tutorial',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    buildStep(
                      Icons.category,
                      'Kategorie und Zeit einstellen',
                      '– Wähle zuerst eine Wort-Kategorie aus (z. B. Tiere, Berufe, Filme).\n– Lege dann die Zeit fest, die der Runtertimer für eure Runde laufen soll.',
                    ),
                    buildStep(
                      Icons.play_arrow,
                      'Spiel starten',
                      '– Halte dein iPhone an deine Stirn.\n– Kippe es nach vorne-unten, um den Timer zu starten und das erste Wort zu erhalten.',
                    ),
                    buildStep(
                      Icons.question_answer,
                      'Erraten und Erklären',
                      '– Spielt zu zweit: Spieler 1 hält das Handy an die Stirn und versucht, das Wort zu erraten.\n– Spieler 2 erklärt das Wort, ohne es zu nennen.\n– Hast du das Wort richtig erraten, kippst du das Handy nach vorne.\n– Hast du es falsch geraten oder möchtest passen, kippst du das Handy nach oben.',
                    ),
                    buildStep(
                      Icons.assessment,
                      'Ergebnis ansehen',
                      '– Am Ende jeder Runde zeigt dir die Übersicht, welche Wörter du richtig und welche du falsch geraten hast.',
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Viel Spaß beim Raten und Erklären! 😃',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor.withOpacity(0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                    Platform.isIOS
                        ? CupertinoButton(
                          color: iconColor,
                          borderRadius: BorderRadius.circular(30),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Fertig',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: iconColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Fertig',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
