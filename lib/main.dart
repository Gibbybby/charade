import 'package:charadex/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app_state.dart';

void main() async {
  // Sicherstellen, dass Widgets und Binding bereit sind
  WidgetsFlutterBinding.ensureInitialized();

  // AppState lädt beim Erzeugen automatisch SharedPreferences
  runApp(
    ChangeNotifierProvider(create: (_) => AppState(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return MaterialApp(
          // Debug-Banner ausschalten
          debugShowCheckedModeBanner: false,

          // Lokalisierung
          locale: appState.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,

          // Optional: Theme und weitere Einstellungen
          theme: ThemeData(primarySwatch: Colors.orange),

          // Startscreen
          home: const CharadePartyHomePage(),
        );
      },
    );
  }
}
