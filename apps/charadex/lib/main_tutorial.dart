import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainTutorialPage extends StatelessWidget {
  const MainTutorialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading:
            Platform.isIOS
                ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                )
                : null,
        title: Text(
          loc.tutorialTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF6A3DC7),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    loc.tutorialText,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child:
                      Platform.isIOS
                          ? CupertinoButton(
                            color: const Color(0xFF6A3DC7),
                            borderRadius: BorderRadius.circular(30),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              loc.done,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : FloatingActionButton.extended(
                            onPressed: () => Navigator.of(context).pop(),
                            backgroundColor: const Color(0xFF6A3DC7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            label: Text(
                              loc.done,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
