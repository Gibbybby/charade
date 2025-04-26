import 'package:charadex/player_mode.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CharadePartyApp());
}

class CharadePartyApp extends StatelessWidget {
  const CharadePartyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PlayerModeScreen(),
    );
  }
}
