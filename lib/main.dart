import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'game_settings.dart';
import 'notification_service.dart';
import 'localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    return ValueListenableBuilder<int>(
      valueListenable: GameSettings.notifier,
      builder: (context, _, __) {
        return MaterialApp(
          title: 'Charade',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: GameSettings.darkMode ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(GameSettings.languageCode),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const HomeScreen(),
        );
      },
    );
  }
}
