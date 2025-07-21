import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'game_settings.dart';
import 'notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GameSettings.load();
  await NotificationService.init();
  await NotificationService.scheduleWeeklyAlternating();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Grid UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
