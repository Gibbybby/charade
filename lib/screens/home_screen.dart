import 'package:charadex/data.dart';
import 'package:charadex/screens/settings_screen.dart';
import 'package:charadex/screens/tutorial.dart';
import 'package:charadex/screens/game_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../game_settings.dart';
import '../localization.dart';
import '../words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color get backgroundColor => Theme.of(context).scaffoldBackgroundColor;
  Color get cardColor => Theme.of(context).cardColor;
  // Highlight color for selected images
  // Use a purple border as requested
  Color get highlightColor => Colors.purple;

  String selectedMenuId = "all";
  final Set<String> selectedImageIds = {};
  bool _showImposterBanner = false;
  int _startCount = 0;

  @override
  void initState() {
    super.initState();
    _initBannerState();
  }

  Future<void> _initBannerState() async {
    final prefs = await SharedPreferences.getInstance();
    _startCount = (prefs.getInt('start_count') ?? 0) + 1;
    await prefs.setInt('start_count', _startCount);
    final nextShow = prefs.getInt('imposter_next_show') ?? 1;
    if (_startCount >= nextShow) {
      setState(() {
        _showImposterBanner = true;
      });
    }
  }

  Future<void> _closeImposterBanner() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('imposter_next_show', _startCount + 3);
    setState(() {
      _showImposterBanner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final filteredImages = selectedMenuId == "all"
        ? imageItems
        : imageItems
            .where((item) =>
                (item["fitMenuItemIds"] as List).contains(selectedMenuId))
            .toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TutorialScreen()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).t('title'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: menuItems.map((item) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMenuId = item["id"];
                        });
                      },
                      child: _menuItem(
                        title: AppLocalizations.of(context).t(item["titleKey"]),
                        isSelected: selectedMenuId == item["id"],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                  children: filteredImages.take(12).map((item) {
                    final isSelected = selectedImageIds.contains(item['id']);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedImageIds.remove(item['id']);
                          } else {
                            selectedImageIds.add(item['id']);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? highlightColor : Colors.transparent,
                            width: 3,
                          ),
                          image: DecorationImage(
                            image: AssetImage(item["imagePath"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(item["imagePath"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12)),
                                  color: Colors.transparent,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .t('category_${item["id"]}')
                                      .toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black,
                                        offset: Offset(0.5, 0.5),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (filteredImages.length > 12) ...[
                SizedBox(height: _showImposterBanner ? 16 : 10),
                if (_showImposterBanner)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _imposterBanner(),
                  ),
                if (_showImposterBanner) const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4,
                    children: filteredImages.skip(12).map((item) {
                      final isSelected = selectedImageIds.contains(item['id']);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedImageIds.remove(item['id']);
                            } else {
                              selectedImageIds.add(item['id']);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? highlightColor : Colors.transparent,
                              width: 3,
                            ),
                            image: DecorationImage(
                              image: AssetImage(item["imagePath"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(item["imagePath"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(12)),
                                    color: Colors.transparent,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .t('category_${item["id"]}')
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 2,
                                          color: Colors.black,
                                          offset: Offset(0.5, 0.5),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(32, 15, 32, 30),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    final selectedItems = selectedImageIds.isEmpty
                        ? imageItems
                        : imageItems
                            .where(
                                (item) => selectedImageIds.contains(item['id']))
                            .toList();
                    final uniqueItems = {
                      for (var item in selectedItems) item['id']: item
                    }.values.toList();
                    final words = <String>[];
                    for (final item in uniqueItems) {
                      words.addAll(Words.forCategory(item['id']));
                    }
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeRight,
                    ]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(words: words),
                      ),
                    );
                  },
                  label: Text(
                    AppLocalizations.of(context).t('start'),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _menuItem({required String title, required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber[600] : cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _imposterBanner() {
    return GestureDetector(
      onTap: () {
        launchUrl(
          Uri.parse('https://apps.apple.com/app/apple-store/id6745120053?pt=126797007&ct=Charade&mt=8'),
        );
      },
      child: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/imposter.png',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).t('imposterTitle'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context).t('imposterSubtitle'),
                        style: const TextStyle(color: Colors.white, fontSize: 14,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: _closeImposterBanner,
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
