import 'package:charadex/data.dart';
import 'package:charadex/screens/settings_screen.dart';
import 'package:charadex/screens/tutorial.dart';
import 'package:charadex/screens/game_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../game_settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final backgroundColor = const Color(0xFF0F0F1C);
  final cardColor = const Color(0xFF1E1E2D);
  final Color highlightColor = Colors.purple;

  String selectedMenuId = "all";
  final Set<String> selectedImageIds = {};

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
        leading: GameSettings.movementsEnabled
            ? null
            : IconButton(
                icon: const Icon(Icons.help_outline, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TutorialScreen()),
                  );
                },
              ),
        centerTitle: true,
        title: const Text(
          'Charade',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: GameSettings.movementsEnabled
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
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
                        title: item["name"],
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
                  children: filteredImages.map((item) {
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
                                  (item["label"] ?? item["id"]).toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
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
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GameSettings.movementsEnabled
          ? null
          : Padding(
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
                      words.addAll(List<String>.from(item['words'] as List));
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
                  label: const Text(
                    "Start",
                    style: TextStyle(
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
