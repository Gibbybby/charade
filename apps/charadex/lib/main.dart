// main.dart
import 'package:charadex/charade_party_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // App global auf Querformat sperren
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
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
