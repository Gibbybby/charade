import 'package:charadex/charade_party_home.dart';
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
      home: const CharadePartyHomePage(),
    );
  }
}
