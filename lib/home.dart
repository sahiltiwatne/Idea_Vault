import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'startup_detail_screen.dart'; // Add this import
import 'search_screen.dart';
import 'startup_form_screen.dart';
import 'leaderboardscreen.dart';

import 'dart:io'; // ADD THIS LINE
 // If you added this
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  bool isDarkMode = false;
  bool showSortDropdown = false;
  late AnimationController _dropdownController;
  late Animation<double> _dropdownAnimation;
  String selectedSortLabel = "Sort by";


  List<Map<String, dynamic>> startups = [
    {
      'logo': 'assets/images/snack.png',
      'name': 'SnackSwap',
      'tagline': 'Trade your snacks, not your secrets.',
      'votes': 243,
      'date': '2025-07-28',
    },
    {
      'logo': 'assets/images/trash.jpg',
      'name': 'Trash2Cash',
      'tagline': 'Turn waste into wealth.',
      'votes': 300,
      'date': '2025-07-30',
    },
    {
      'logo': 'assets/images/ghost.png',
      'name': 'GhostChef',
      'tagline': 'Invisible chefs, unforgettable meals.',
      'votes': 298,
      'date': '2025-07-29',
    },
    {
      'logo': 'assets/images/petmatch.png',
      'name': 'PetMatch',
      'tagline': 'Swipe right to find your pet playmate.',
      'votes': 189,
      'date': '2025-07-25',
    },
    {
      'logo': 'assets/images/farmfresh.png',
      'name': 'FarmFresh',
      'tagline': 'From farm to fork, fresher than ever.',
      'votes': 215,
      'date': '2025-07-27',
    },
    {
      'logo': 'assets/images/bookloop.png',
      'name': 'BookLoop',
      'tagline': 'Read. Return. Repeat.',
      'votes': 176,
      'date': '2025-07-26',
    },
    // NEW STARTUP IDEAS:
    {
      'logo': 'assets/images/sleeptech.png', // Use existing images temporarily
      'name': 'SleepTech',
      'tagline': 'Smart dreams for smarter mornings.',
      'votes': 267,
      'date': '2025-07-31',
    },
    {
      'logo': 'assets/images/plantpal.png',
      'name': 'PlantPal',
      'tagline': 'Your AI gardening companion.',
      'votes': 234,
      'date': '2025-08-01',
    },
    {
      'logo': 'assets/images/mindspace.png',
      'name': 'MindSpace',
      'tagline': 'Virtual therapy for busy minds.',
      'votes': 289,
      'date': '2025-08-02',
    },
    {
      'logo': 'assets/images/quickfix.png',
      'name': 'QuickFix',
      'tagline': 'Home repairs in under 60 minutes.',
      'votes': 321,
      'date': '2025-08-03',
    },
    {
      'logo': 'assets/images/studybuddy.png',
      'name': 'StudyBuddy',
      'tagline': 'AI tutors that actually get you.',
      'votes': 198,
      'date': '2025-07-24',
    },
    {
      'logo': 'assets/images/Carbonzero.png',
      'name': 'CarbonZero',
      'tagline': 'Track your footprint, save the planet.',
      'votes': 256,
      'date': '2025-07-23',
    },
    {
      'logo': 'assets/images/fashionloop.jpg',
      'name': 'FashionLoop',
      'tagline': 'Rent designer clothes, not closet space.',
      'votes': 278,
      'date': '2025-07-22',
    },

    {
      'logo': 'assets/images/fitnessai.jpg',
      'name': 'FitnessAI',
      'tagline': 'Personal trainer in your pocket.',
      'votes': 312,
      'date': '2025-07-19',
    },

  ];


  late List<bool> upvoted;

// Color getters for theme-aware colors
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F4F4);

  Color get cardColor => isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

  Color get cardBackgroundColor =>
      isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFF6F6F6);

  Color get textColor => isDarkMode ? Colors.white : Colors.black;

  Color get subtitleColor => isDarkMode ? Colors.white70 : Colors.black87;

  Color get iconColor => isDarkMode ? Colors.white : Colors.black;

  @override
  void initState() {
    super.initState();
    upvoted = List.generate(startups.length, (_) => false);
    loadUpvoted();
    loadThemePreference();
    sortStartups();
    _dropdownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _dropdownAnimation = CurvedAnimation(
      parent: _dropdownController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _dropdownController.dispose();
    super.dispose();
  }

  void sortStartups() {
    startups.sort((a, b) => b['votes'].compareTo(a['votes']));
  }

  void toggleSortDropdown() {
    setState(() {
      showSortDropdown = !showSortDropdown;
      if (showSortDropdown) {
        _dropdownController.forward();
      } else {
        _dropdownController.reverse();
      }
    });
  }

  void applySort(String sortType) {
    setState(() {
      selectedSortLabel = sortType;
      if (sortType == "Most Votes") {
        startups.sort((a, b) => b['votes'].compareTo(a['votes']));
      } else if (sortType == "Name A-Z") {
        startups.sort((a, b) => a['name'].compareTo(b['name']));
      } else if (sortType == "Name Z-A") {
        startups.sort((a, b) => b['name'].compareTo(a['name']));
      } else if (sortType == "Newest") {
        startups.sort((a, b) {
          final dateA = DateTime.tryParse(a['date'] ?? '') ?? DateTime(2000);
          final dateB = DateTime.tryParse(b['date'] ?? '') ?? DateTime(2000);
          return dateB.compareTo(dateA);
        });
      } else if (sortType == "Oldest") {
        startups.sort((a, b) {
          final dateA = DateTime.tryParse(a['date'] ?? '') ?? DateTime(2000);
          final dateB = DateTime.tryParse(b['date'] ?? '') ?? DateTime(2000);
          return dateA.compareTo(dateB);
        });
      }
    });

    toggleSortDropdown(); // Move outside setState for clarity
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(Icons.settings, size: 28, color: iconColor),
        ),
        actions: const [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Team image (static in background)
            Positioned(
              top: 100,
              right: 0,
              child: Opacity(
                opacity: isDarkMode ? 0.3 : 0.7,
                child: Image.asset(
                  'assets/images/team.png',
                  height: 250,
                ),
              ),
            ),

            // Main Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Buttons
                Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  // reduced from 16
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min, // prevent expansion
                        children: [
                          GestureDetector(
                            onTap: toggleSortDropdown,
                            child: filterButton(Icons.bar_chart,
                                selectedSortLabel),
                          ),
                          const SizedBox(width: 12),
                          filterButton(Icons.lightbulb_outline, 'Your Ideas'),
                        ],
                      ),
                      Transform.scale(
                        scale: 0.9, // slightly smaller switch
                        child: Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            setState(() {
                              isDarkMode = value;
                            });
                            saveThemePreference();
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),


                if (showSortDropdown)
                  SizeTransition(
                    sizeFactor: _dropdownAnimation,
                    axisAlignment: -1.0,
                    child: FadeTransition(
                      opacity: _dropdownAnimation,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors
                            .white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSortOption("Most Votes"),
                            _buildSortOption("Newest"),
                            _buildSortOption("Oldest"),

                          ],
                        ),
                      ),
                    ),
                  ),


                const SizedBox(height: 20),

                // Heading
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "July 28 - August 3",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Last Week Top Ideas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Scrollable cards only
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 190),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: List.generate(startups.length, (index) {
                          final startup = startups[index];
                          return startupCard(
                            index: index,
                            logo: startup['logo'],
                            name: startup['name'],
                            tagline: startup['tagline'],
                            votes: startup['votes'],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StartupFormScreen(
                    isDarkMode: isDarkMode,
                    onSubmitIdea: (newStartup) {
                      setState(() {
                        startups.insert(
                            0, newStartup); // Add to beginning of list
                        upvoted.insert(
                            0, false); // Add corresponding upvote state
                        sortStartups(); // Re-sort the list
                      });
                      saveUpvoted(); // Save the updated state
                    },
                  ),
            ),
          );
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: cardColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(Icons.home, 0, 'Home'),
              navItem(Icons.search, 1, 'Search'),
              const SizedBox(width: 40),
              navItem(Icons.leaderboard, 2, 'Leaderboard'),
              navItem(Icons.access_time, 3, 'Activity'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String label) {
    return InkWell(
      onTap: () => applySort(label),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }


  // 2. SECOND: Update your loadUpvoted() method to handle the new list length:

  void loadUpvoted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedVotes = prefs.getString('upvoted');
    if (savedVotes != null) {
      List<bool> loaded = List<bool>.from(json.decode(savedVotes));
      // Ensure the loaded list matches current startup list length
      if (loaded.length != startups.length) {
        // Extend or truncate to match current startups length
        while (loaded.length < startups.length) {
          loaded.add(false);
        }
        if (loaded.length > startups.length) {
          loaded = loaded.sublist(0, startups.length);
        }
      }
      setState(() {
        upvoted = loaded;
      });
    } else {
      upvoted = List.generate(startups.length, (_) => false);
    }
  }

  void saveUpvoted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('upvoted', json.encode(upvoted));
  }

  void loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  // Add this import

// Replace your existing navItem widget with this updated version:
  Widget navItem(IconData icon, int index, String label) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        // Add navigation logic here
        if (index == 1) { // Search screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          ).then((_) {
            // When returning from search screen, set home as selected
            setState(() {
              selectedIndex = 0;
            });
          });
        }
        if (index == 2) { // Leaderboard screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LeaderboardScreen(
                startups: startups,
                isDarkMode: isDarkMode,
              ),
            ),
          ).then((_) {
            setState(() {
              selectedIndex = 0; // Reset to home when returning
            });
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? Colors.green : (isDarkMode
                ? Colors.white60
                : Colors.grey),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.green : (isDarkMode
                  ? Colors.white60
                  : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isDarkMode ? Border.all(color: Colors.white24) : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

// UPDATED startupCard widget with navigation
  Widget startupCard({
    required int index,
    required String logo,
    required String name,
    required String tagline,
    required int votes,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartupDetailScreen(
              startup: {
                'logo': logo,
                'name': name,
                'tagline': tagline,
                'description': startups[index]['description'],
                // ✅ Add this line
                'votes': votes,
              },
              isDarkMode: isDarkMode,
              isAlreadyUpvoted: upvoted[index],
            ),
          ),
        );

      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            // UPDATED: Handle both asset images and file images
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: cardColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildStartupImage(logo),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tagline,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up_alt,
                    color: upvoted[index] ? Colors.green : (isDarkMode ? Colors
                        .white60 : Colors.grey),
                  ),
                  onPressed: () {
                    setState(() {
                      if (upvoted[index]) {
                        startups[index]['votes'] -= 1;
                      } else {
                        startups[index]['votes'] += 1;
                      }
                      upvoted[index] = !upvoted[index];
                      sortStartups();
                    });
                    saveUpvoted();
                  },
                ),
                Text(
                  votes.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// ADD this new helper method to your HomeScreen class:
  Widget _buildStartupImage(String logoPath) {
    // Check if it's a file path (user uploaded image)
    if (logoPath.startsWith('/') || logoPath.contains('cache') ||
        logoPath.contains('Documents')) {
      // It's a file path - use Image.file()
      try {
        return Image.file(
          File(logoPath),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultLogo();
          },
        );
      } catch (e) {
        return _buildDefaultLogo();
      }
    } else {
      // It's an asset path - use Image.asset()
      return Image.asset(
        logoPath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultLogo();
        },
      );
    }
  }

// ADD this helper method for default logo:
  Widget _buildDefaultLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.business,
        color: isDarkMode ? Colors.white60 : Colors.grey[600],
        size: 24,
      ),
    );
  }
}
