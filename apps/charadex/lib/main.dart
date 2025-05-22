import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charadex/start_screen.dart';
import 'app_state.dart'; // Stelle sicher, dass der Pfad stimmt

void main() {
  runApp(
    ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: const CharadePartyApp(),
    ),
  );
}

class CharadePartyApp extends StatelessWidget {
  const CharadePartyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CharadePartyHomePage(),
    );
  }
}
