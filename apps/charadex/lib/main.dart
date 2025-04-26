import 'package:flutter/material.dart';
import 'charade_party_home.dart'; // Import this file

void main() {
  runApp(const CharadePartyApp());
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
