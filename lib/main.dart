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
        final baseDark = ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0F0F1C),
          cardColor: const Color(0xFF1E1E2D),
          colorScheme: ThemeData.dark()
              .colorScheme
              .copyWith(primary: Colors.amber[600]),
        );
        final baseLight = ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0F0F1C),
          cardColor: const Color(0xFF1E1E2D),
          colorScheme: ThemeData.light()
              .colorScheme
              .copyWith(primary: Colors.amber[600]),
        );
        return MaterialApp(
          title: 'Charade',
          debugShowCheckedModeBanner: false,
          theme: baseLight,
          darkTheme: baseDark,
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
