import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int selectedIndex = 1; // Search is selected
  bool isDarkMode = false;
  TextEditingController searchController = TextEditingController();

  // Color getters for theme-aware colors (same as home screen)
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F4F4);

  Color get cardColor => isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

  Color get textColor => isDarkMode ? Colors.white : Colors.black;

  Color get subtitleColor => isDarkMode ? Colors.white70 : Colors.black54;

  Color get iconColor => isDarkMode ? Colors.white : Colors.black;

  @override
  void initState() {
    super.initState();
    loadThemePreference();
  }

  void loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar (constant at top)
            Container(
              padding: const EdgeInsets.all(16),
              color: backgroundColor,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(25),
                        border: isDarkMode ? Border.all(color: Colors.white24) : null,
                      ),
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(color: textColor, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Search for StartUps',
                          hintStyle: TextStyle(color: subtitleColor, fontSize: 16),
                          prefixIcon: Icon(Icons.search, color: subtitleColor, size: 24),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Popular Topics Section
                    Text(
                      'Popular Topics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Topic Pills
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildTopicPill('Food', const Color(0xFFFDD835)),
                        _buildTopicPill('Tech', const Color(0xFF4DD0E1)),
                        _buildTopicPill('Artificial Intelligence', const Color(0xFFE91E63)),
                        _buildTopicPill('Marketing', const Color(0xFF689F38)),
                        _buildTopicPill('Productivity', const Color(0xFFFF9800)),
                        _buildTopicPill('Medical', const Color(0xFF1A237E)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // View all Topics
                    GestureDetector(
                      onTap: () {
                        // Handle view all topics
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'View all Topics',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: textColor,
                            size: 24,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Time Machine Section
                    Text(
                      'Time Machine',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Time Machine Options
                    _buildTimeMachineOption(
                      icon: Icons.wb_sunny,
                      iconColor: const Color(0xFFFDD835),
                      title: 'Yesterday',
                      subtitle: 'Top Ideas from Yesterday',
                    ),
                    _buildTimeMachineOption(
                      icon: Icons.access_time,
                      iconColor: const Color(0xFFE91E63),
                      title: 'Last week',
                      subtitle: 'Top Ideas from last 7 days',
                    ),
                    _buildTimeMachineOption(
                      icon: Icons.schedule,
                      iconColor: const Color(0xFF1976D2),
                      title: 'Last month',
                      subtitle: 'Top Ideas from last 30 days',
                    ),
                    _buildTimeMachineOption(
                      icon: Icons.history,
                      iconColor: const Color(0xFF388E3C),
                      title: 'Last Year',
                      subtitle: 'Top Ideas from last 365 days',
                    ),

                    const SizedBox(height: 32),

                    // Who to follow Section
                    Text(
                      'Who to follow',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Profile Cards
                    _buildProfileCard(
                      profileImage: 'assets/images/profile.jpg',
                      name: 'Sarah Chen',
                      followers: '2.3K',
                    ),
                    _buildProfileCard(
                      profileImage: 'assets/images/profile.jpg',
                      name: 'Alex Johnson',
                      followers: '1.8K',
                    ),
                    _buildProfileCard(
                      profileImage: 'assets/images/profile.jpg',
                      name: 'Maria Rodriguez',
                      followers: '3.1K',
                    ),
                    _buildProfileCard(
                      profileImage: 'assets/images/profile.jpg',
                      name: 'David Kim',
                      followers: '956',
                    ),

                    const SizedBox(height: 100), // Extra space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // No logic for now
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
              navItem(Icons.newspaper, 2, 'News'),
              navItem(Icons.access_time, 3, 'Activity'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTimeMachineOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle time machine option tap
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: isDarkMode ? Border.all(color: Colors.white24) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String profileImage,
    required String name,
    required String followers,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isDarkMode ? Border.all(color: Colors.white24) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(profileImage),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$followers followers',
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Follow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, int index, String label) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        // Navigate to appropriate screen
        if (index == 0) {
          Navigator.pop(context); // Go back to home
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
}