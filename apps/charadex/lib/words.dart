import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Erzwinge Querformat (Landscape)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Querformat Beispiel',
      debugShowCheckedModeBanner: false,
      home: LandscapePage(),
    );
  }
}

class LandscapePage extends StatelessWidget {
  const LandscapePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Querformat-Seite')),
      body: const Center(
        child: Text(
          'WORT',
          style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
