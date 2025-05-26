import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const _languageCodes = ['de', 'en', 'hr', 'es', 'zh'];

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final appState = Provider.of<AppState>(context);
    final sliderValue = appState.timerSeconds.clamp(10, 120).toDouble();

    String _displayName(String code) {
      switch (code) {
        case 'de':
          return 'Deutsch';
        case 'en':
          return 'English';
        case 'hr':
          return 'Hrvatski';
        case 'es':
          return 'Español';
        case 'zh':
          return 'Chinese (中文)';
        default:
          return code;
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          loc.settings,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF5F8D), Color(0xFFFFA726)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Language
              _buildCard(
                context,
                icon: Icons.language,
                title: loc.languageLabel,
                child: InkWell(
                  onTap:
                      () =>
                          _showLanguagePicker(context, appState, _displayName),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _displayName(appState.languageCode),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Timer
              _buildCardWithValue(
                context,
                icon: Icons.timer,
                title: loc.timerLabel,
                value: "${appState.timerSeconds} ${loc.secondsAbbr}",
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: const Color(0xFFFFA726),
                    activeTrackColor: const Color(0xFFFFA726),
                    inactiveTrackColor: const Color(
                      0xFFFFA726,
                    ).withOpacity(0.3),
                    overlayColor: Colors.transparent,
                    showValueIndicator: ShowValueIndicator.never,
                  ),
                  child: Slider(
                    value: sliderValue,
                    min: 10,
                    max: 120,
                    divisions: 11,
                    onChanged:
                        (newValue) => appState.setTimer(newValue.round()),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // More Free Apps Section
              _buildCard(
                context,
                icon: Icons.apps,
                title: loc.moreApps,
                child: Column(
                  children: [
                    _appEntry(
                      asset: 'assets/icons/partybomb.png',
                      title: 'PartyBomb',
                      subtitle: loc.appPartyBombSubtitle,
                      link:
                          'https://apps.apple.com/app/apple-store/id6746101066?pt=126797007&ct=GuessUp&mt=8',
                    ),
                    _appEntry(
                      asset: 'assets/icons/imposter.png',
                      title: 'Imposter',
                      subtitle: loc.appImposterSubtitle,
                      link:
                          'https://apps.apple.com/app/apple-store/id6745120053?pt=126797007&ct=GuessUp&mt=8',
                    ),
                    _appEntry(
                      asset: 'assets/icons/pikapika.png',
                      title: 'PikaPika',
                      subtitle: loc.appPikaPikaSubtitle,
                      link:
                          'https://apps.apple.com/app/apple-store/id6744726904?pt=126797007&ct=GuessUp&mt=8',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appEntry({
    required String asset,
    required String title,
    required String subtitle,
    required String link,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openLink(link),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                asset,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    AppState appState,
    String Function(String) displayName,
  ) {
    final loc = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  loc.languageLabel,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._languageCodes.map((code) {
                final selected = appState.languageCode == code;
                return ListTile(
                  title: Text(
                    displayName(code),
                    style: const TextStyle(color: Colors.black),
                  ),
                  trailing:
                      selected
                          ? const Icon(Icons.check, color: Colors.orange)
                          : null,
                  onTap: () {
                    appState.setLanguageCode(code);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildCardWithValue(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
