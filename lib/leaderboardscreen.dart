import 'package:flutter/material.dart';
import 'dart:io';
import 'startup_detail_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  final List<Map<String, dynamic>> startups;
  final bool isDarkMode;

  const LeaderboardScreen({
    super.key,
    required this.startups,
    required this.isDarkMode,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Color getters for theme-aware colors
  Color get backgroundColor =>
      widget.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F4F4);

  Color get cardColor => widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

  Color get cardBackgroundColor =>
      widget.isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFF6F6F6);

  Color get textColor => widget.isDarkMode ? Colors.white : Colors.black;

  Color get subtitleColor => widget.isDarkMode ? Colors.white70 : Colors.black87;

  Color get iconColor => widget.isDarkMode ? Colors.white : Colors.black;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getTopStartups() {
    List<Map<String, dynamic>> sortedStartups = List.from(widget.startups);
    sortedStartups.sort((a, b) => b['votes'].compareTo(a['votes']));
    return sortedStartups.take(5).toList();
  }

  Widget _buildAwardBadges(int rank) {
    List<Widget> badges = [];
    Color badgeColor;

    if (rank == 1) {
      badgeColor = const Color(0xFFFFD700); // Gold
      badges = List.generate(3, (index) => _buildBadge(badgeColor));
    } else if (rank == 2) {
      badgeColor = const Color(0xFF87CEEB); // Sky Blue
      badges = List.generate(2, (index) => _buildBadge(badgeColor));
    } else if (rank == 3) {
      badgeColor = const Color(0xFFCD7F32); // Bronze
      badges = [_buildBadge(badgeColor)];
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: badges.map((badge) => Padding(
        padding: const EdgeInsets.only(left: 2),
        child: badge,
      )).toList(),
    );

  }

  Widget _buildBadge(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.workspace_premium,
          color: color,
          size: 24, // Reduced from 28
        ),
        const Icon(
          Icons.star,
          color: Colors.white,
          size: 12, // Reduced from 14
        ),
      ],
    );
  }

  Widget _buildRankIndicator(int rank) {
    Color rankColor;
    IconData rankIcon;

    switch (rank) {
      case 1:
        rankColor = const Color(0xFFFFD700); // Gold
        rankIcon = Icons.emoji_events;
        break;
      case 2:
        rankColor = const Color(0xFF87CEEB); // Sky Blue (better silver)
        rankIcon = Icons.emoji_events;
        break;
      case 3:
        rankColor = const Color(0xFFCD7F32); // Bronze
        rankIcon = Icons.emoji_events;
        break;
      default:
        rankColor = widget.isDarkMode ? Colors.white60 : Colors.grey[600]!;
        rankIcon = Icons.star_outline;
    }

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: rankColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: rankColor.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: rankColor.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        rankIcon,
        color: rankColor,
        size: 22,
      ),
    );
  }

  Widget _buildStartupImage(String logoPath) {
    if (logoPath.startsWith('/') || logoPath.contains('cache') ||
        logoPath.contains('Documents')) {
      try {
        return Image.file(
          File(logoPath),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultLogo();
          },
        );
      } catch (e) {
        return _buildDefaultLogo();
      }
    } else {
      return Image.asset(
        logoPath,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultLogo();
        },
      );
    }
  }

  Widget _buildDefaultLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.grey[700] : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.business,
        color: widget.isDarkMode ? Colors.white60 : Colors.grey[600],
        size: 28,
      ),
    );
  }

  Widget _buildLeaderboardCard({
    required int rank,
    required String logo,
    required String name,
    required String tagline,
    required int votes,
    required Map<String, dynamic> startup,
  }) {
    Color getRankColor() {
      switch (rank) {
        case 1:
          return const Color(0xFFFFD700); // Gold
        case 2:
          return const Color(0xFF87CEEB); // Sky Blue (better silver)
        case 3:
          return const Color(0xFFCD7F32); // Bronze
        default:
          return Colors.transparent;
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartupDetailScreen(
              startup: startup,
              isDarkMode: widget.isDarkMode,
              isAlreadyUpvoted: false, // You might want to track this properly
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200 + (rank * 100)),
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: rank <= 3
              ? [
            BoxShadow(
              color: getRankColor().withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ]
              : [
            BoxShadow(
              color: widget.isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
          border: rank <= 3
              ? Border.all(
            color: getRankColor().withOpacity(0.4),
            width: 2,
          )
              : null,
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // Left side - Logo only (replacing rank indicator position)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkMode
                          ? Colors.black.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildStartupImage(logo),
                ),
              ),

              const SizedBox(width: 20),

              // Middle - Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Startup Name with rank badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: textColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: getRankColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: getRankColor().withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '#$rank',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: rank <= 3
                                  ? (widget.isDarkMode ? getRankColor() : getRankColor().withOpacity(0.8))
                                  : subtitleColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      tagline,
                      style: TextStyle(
                        fontSize: 15,
                        color: subtitleColor,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Bottom row - Votes and Badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Vote count with background
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // less padding
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.thumb_up_alt,
                                size: 14, // smaller icon
                                color: Colors.green,
                              ),
                              const SizedBox(width: 4), // less spacing
                              Text(
                                '$votes votes',
                                style: TextStyle(
                                  fontSize: 11, // smaller font
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),


                        // Award badges with proper spacing
                        if (rank <= 3)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildAwardBadges(rank),
                              ],
                            ),
                          ),

                      ],
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

  @override
  Widget build(BuildContext context) {
    final topStartups = getTopStartups();

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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "August 3",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Today's Leaderboard",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Leaderboard Cards
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // Trophy header for top 3
                          if (topStartups.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.emoji_events,
                                    color: const Color(0xFFFFD700),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Top Performers",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Leaderboard items
                          ...List.generate(topStartups.length, (index) {
                            final startup = topStartups[index];
                            return _buildLeaderboardCard(
                              rank: index + 1,
                              logo: startup['logo'],
                              name: startup['name'],
                              tagline: startup['tagline'],
                              votes: startup['votes'],
                              startup: startup,
                            );
                          }),

                          // Empty state if no startups
                          if (topStartups.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.leaderboard,
                                    size: 64,
                                    color: widget.isDarkMode ? Colors.white30 : Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No ideas yet!",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: subtitleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Be the first to share your startup idea",
                                    style: TextStyle(
                                      color: subtitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: cardColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_outlined, Icons.home, 0, 'Home'),
            _navItem(Icons.search_outlined, Icons.search, 1, 'Search'),
            const SizedBox(width: 40), // Space for FAB
            _navItem(Icons.leaderboard_outlined, Icons.leaderboard, 2, 'Leaderboard'),
            _navItem(Icons.access_time_outlined, Icons.access_time, 3, 'Activity'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData outlinedIcon, IconData filledIcon, int index, String label) {
    final isSelected = index == 2; // Always show leaderboard as selected
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.pop(context);
        }
        // Add navigation for other tabs as needed
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? filledIcon : outlinedIcon,
            size: 28,
            color: isSelected ? Colors.green : (widget.isDarkMode ? Colors.white60 : Colors.grey),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.green : (widget.isDarkMode ? Colors.white60 : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
