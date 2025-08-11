import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class StartupDetailScreen extends StatefulWidget {
  final Map<String, dynamic> startup;
  final bool isDarkMode;
  final bool isAlreadyUpvoted;

  const StartupDetailScreen({
    super.key,
    required this.startup,
    this.isDarkMode = false,
    this.isAlreadyUpvoted = false,
  });

  @override
  State<StartupDetailScreen> createState() => _StartupDetailScreenState();
}

class _StartupDetailScreenState extends State<StartupDetailScreen> {
  bool isUpvoted = false;
  int currentVotes = 0;
  late bool isDarkMode;
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  late List<Map<String, dynamic>> currentComments;

  // Startup descriptions for each startup
  final Map<String, String> startupDescriptions = {
    'SnackSwap': 'SnackSwap is a fun and innovative snack-sharing platform that connects snack lovers and encourages a culture of taste exploration. Users can list snacks they have, browse snacks from others nearby, and swap them directly or through pickup/delivery options. Whether it\'s homemade treats, local delicacies, or unique packaged snacks from different regions, SnackSwap makes discovering new flavors easy, affordable, and social. By blending community interaction with convenience, SnackSwap turns everyday snacking into an adventure of connection and discovery.',
    'Trash2Cash': 'Trash2Cash revolutionizes waste management by creating a circular economy where your trash becomes treasure. Our platform connects households and businesses with recycling centers, waste buyers, and upcycling artisans. Users can photograph their waste, get instant price quotes, and schedule pickups. From electronics to organic waste, everything has value in our ecosystem.',
    'GhostChef': 'GhostChef brings professional cooking directly to your kitchen through invisible culinary experts. Our network of certified chefs work behind the scenes, preparing restaurant-quality meals in ghost kitchens optimized for delivery. Experience gourmet dining without the restaurant markup, with meals prepared by invisible hands but unforgettable taste.',
    'PetMatch': 'PetMatch is the ultimate social platform for pets and their owners. Like a dating app for furry friends, owners can create profiles for their pets, browse nearby companions, and arrange playdates. Features include compatibility matching based on size, energy level, and temperament, plus integrated chat for coordinating meetups.',
    'FarmFresh': 'FarmFresh creates direct connections between local farmers and consumers, eliminating middlemen and ensuring the freshest produce reaches your table. Our platform allows farmers to list their harvest, consumers to place orders, and provides logistics for same-day delivery from farm to fork.',
    'BookLoop': 'BookLoop transforms reading into a sustainable, community-driven experience. Our circular library system lets users borrow, lend, and discover books within their neighborhood. Read your favorite titles, return them when done, and discover new authors through our recommendation engine powered by community reviews.',
    'SleepTech': 'SleepTech uses advanced sensors and AI to track your sleep patterns, detect disruptions, and provide personalized tips for better rest. From dream analysis to smart alarm systems that wake you at the perfect moment, SleepTech helps you wake up refreshed and ready for the day.',
    'PlantPal': 'PlantPal is your AI-powered gardening companion that monitors plant health, provides care reminders, and suggests optimal watering and sunlight schedules. Whether you\'re a beginner or a seasoned gardener, PlantPal ensures your green friends thrive year-round.',
    'MindSpace': 'MindSpace offers virtual therapy sessions, guided meditations, and stress management tools tailored to busy lifestyles. Connect with certified mental health professionals anytime, anywhere, and take control of your emotional wellbeing.',
    'QuickFix': 'QuickFix connects you to vetted repair professionals for urgent home maintenance needs — from plumbing leaks to electrical faults — all within 60 minutes. Track your service provider in real-time and pay securely through the app.',
    'StudyBuddy': 'StudyBuddy is an AI tutor that understands your learning style and adapts study plans for maximum retention. With interactive quizzes, instant doubt-solving, and progress tracking, it makes learning efficient and engaging.',
    'CarbonZero': 'CarbonZero helps individuals and businesses track, reduce, and offset their carbon footprint. Through actionable tips, green product recommendations, and verified offset programs, it makes sustainability simple and impactful.',
    'FashionLoop': 'FashionLoop is a rental platform for designer clothing and accessories, allowing you to look stunning without filling your closet. Perfect for weddings, parties, and photoshoots — wear luxury without the long-term price tag.',
    'FitnessAI': 'FitnessAI delivers personalized workout and nutrition plans powered by AI. From tracking your progress to adjusting your routines in real time, it acts like a personal trainer in your pocket.'
  };

  final Map<String, String> startupMakers = {
    'SnackSwap': 'Sujal Bhagat',
    'Trash2Cash': 'Arjun Mehta',
    'GhostChef': 'Priya Sharma',
    'PetMatch': 'Kiran Patel',
    'FarmFresh': 'Rajesh Kumar',
    'BookLoop': 'Ananya Singh',
    'SleepTech': 'Aditya Menon',
    'PlantPal': 'Rhea Kapoor',
    'MindSpace': 'Vikram Bansal',
    'QuickFix': 'Nikhil Deshmukh',
    'StudyBuddy': 'Tanvi Iyer',
    'CarbonZero': 'Harsh Verma',
    'FashionLoop': 'Sanya Malhotra',
    'FitnessAI': 'Rohit Chawla'
  };

  final Map<String, List<Map<String, dynamic>>> startupComments = {
  'SnackSwap': [
  {
  'name': 'Sanjay Thakur',
  'time': '1 day ago',
  'comment': 'I love the idea! SnackSwap sounds perfect for trying new treats without spending a fortune. As a foodie, I\'m excited to connect with others who appreciate unique snacks. Plus, sharing with neighbors makes it feel even more fun and community-driven!'
  },
  {
  'name': 'Suraj Patil',
  'time': '2 day ago',
  'comment': 'This is such a creative concept! Being able to swap local and homemade snacks adds a personal touch you can\'t find in stores. I think it\'ll help people discover flavors from different backgrounds while making new friends.'
  },
  {
  'name': 'Shikha Savla',
  'time': '3 day ago',
  'comment': 'SnackSwap could really shake up how we snack. I appreciate the mix of convenience and community—it makes everyday snacking more social and adventurous. Can\'t wait to try something new and share my favorites!'
  }
  ],
  'Trash2Cash': [
  {
  'name': 'Rahul Gupta',
  'time': '1 day ago',
  'comment': 'Finally, a solution that makes recycling profitable! This could really motivate people to be more conscious about waste. Love the idea of turning trash into actual cash.'
  },
  {
  'name': 'Meera Joshi',
  'time': '2 day ago',
  'comment': 'The circular economy approach is brilliant. This could solve both environmental and economic issues simultaneously. Great concept!'
  }
  ],
  'GhostChef': [
  {
  'name': 'Vikram Singh',
  'time': '1 day ago',
  'comment': 'Gourmet food without restaurant prices? Count me in! The ghost kitchen concept is innovative and could revolutionize food delivery.'
  },
  {
  'name': 'Neha Kapoor',
  'time': '2 day ago',
  'comment': 'Love the mystery element! Getting restaurant-quality food prepared by invisible chefs sounds intriguing and delicious.'
  }
  ],
  'PetMatch': [
  {
  'name': 'Amit Sharma',
  'time': '1 day ago',
  'comment': 'My dog would love this! It\'s so hard to find compatible playmates. The matching algorithm based on temperament is genius.'
  },
  {
  'name': 'Pooja Reddy',
  'time': '2 day ago',
  'comment': 'Such a needed app for pet parents! Socializing pets is important, and this makes it so much easier to find the right matches.'
  }
  ],
  'FarmFresh': [
  {
  'name': 'Sandeep Patel',
  'time': '1 day ago',
  'comment': 'Supporting local farmers while getting the freshest produce - this is a win-win! The farm-to-fork concept is exactly what we need.'
  },
  {
  'name': 'Kavya Nair',
  'time': '2 day ago',
  'comment': 'Love supporting local agriculture! This platform could really help small farmers reach more customers directly.'
  }
  ],
  'BookLoop': [
  {
  'name': 'Rohit Verma',
  'time': '1 day ago',
  'comment': 'As an avid reader, this sounds perfect! Sustainable reading with community recommendations - brilliant idea for book lovers.'
  },
  {
  'name': 'Shreya Das',
  'time': '2 day ago',
  'comment': 'The circular library concept is amazing! This could make reading more affordable and help discover new authors through the community.'
  }
  ],
  'SleepTech': [
  {
  'name': 'Kunal Joshi',
  'time': '1 day ago',
  'comment': 'I\'ve always struggled with irregular sleep. If this app can actually wake me up at the right time, I\'m in!'
  },
  {
  'name': 'Neeta Agarwal',
  'time': '2 day ago',
  'comment': 'Love the idea of tracking dreams and sleep cycles. Could be a game-changer for health-conscious people.'
  }
  ],
  'PlantPal': [
  {
  'name': 'Anil Saxena',
  'time': '1 day ago',
  'comment': 'Perfect for people like me who forget to water plants. This could save a lot of green lives!'
  },
  {
  'name': 'Mansi Kulkarni',
  'time': '2 day ago',
  'comment': 'AI gardening assistant sounds so futuristic. Cant wait to try it with my balcony garden.'
}
],
'MindSpace': [
{
'name': 'Devansh Kapoor',
'time': '1 day ago',
'comment': 'Mental health should be accessible to all, and this makes it so much easier.'
},
{
'name': 'Ritika Sharma',
'time': '2 day ago',
'comment': 'Love that I can get therapy without commuting. Saves time and anxiety.'
}
],
'QuickFix': [
{
'name': 'Ramesh Iyer',
'time': '1 day ago',
'comment': 'An emergency repair in under an hour? Sign me up. This is every homeowners dream.'
},
{
'name': 'Swati Desai',
'time': '2 day ago',
'comment': 'Had a sudden leak last week — something like this wouldve saved me so much stress!'
}
],
'StudyBuddy': [
{
'name': 'Ishaan Malhotra',
'time': '1 day ago',
'comment': 'An AI tutor that understands me better than my textbooks? This is huge for students.'
},
{
'name': 'Priya Nair',
'time': '2 day ago',
'comment': 'Could make studying way less boring and more interactive. I love it already.'
}
],
'CarbonZero': [
{
'name': 'Vivek Jain',
'time': '1 day ago',
'comment': 'It\'s about time we had a tool to track our carbon footprint so easily.'
},
{
'name': 'Nidhi Chatterjee',
'time': '2 day ago',
'comment': 'Love the actionable tips! Makes me feel like I actually helping the planet.'
}
],
'FashionLoop': [
{
'name': 'Arjun Khanna',
'time': '1 day ago',
'comment': 'Designer outfits for a night without spending a fortune? Count me in.'
},
{
'name': 'Megha Sinha',
'time': '2 day ago',
'comment': 'Perfect for weddings and parties — no more repeating the same outfit.'
}
],
'FitnessAI': [
{
'name': 'Sameer Pathak',
'time': '1 day ago',
'comment': 'Finally, a personal trainer that available 24/7. This could keep me consistent.'
},
{
'name': 'Ananya Bose',
'time': '2 day ago',
'comment': 'The idea of an AI adjusting my workouts in real time is amazing.'
}
]
};

// Color getters for theme-aware colors
Color get backgroundColor => isDarkMode ? const Color(0xFF121212) : const Color(0xFFF4F4F4);
Color get cardColor => isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
Color get textColor => isDarkMode ? Colors.white : Colors.black;
Color get subtitleColor => isDarkMode ? Colors.white70 : Colors.black87;

@override
void initState() {
  super.initState();
  currentVotes = widget.startup['votes'];
  isDarkMode = widget.isDarkMode;
  isUpvoted = widget.isAlreadyUpvoted;
  final String startupName = widget.startup['name'];
  currentComments = List<Map<String, dynamic>>.from(startupComments[startupName] ?? []);
}

@override
void dispose() {
  _commentController.dispose();
  _commentFocusNode.dispose();
  super.dispose();
}

void _addComment() {
  if (_commentController.text.trim().isNotEmpty) {
    setState(() {
      currentComments.insert(0, {
        'name': 'You',
        'time': 'now',
        'comment': _commentController.text.trim(),
      });
    });
    _commentController.clear();
  }
}

// Helper method to build startup logo (handles both asset and file images)
Widget _buildStartupLogo(String logoPath) {
  // Check if it's a file path (user uploaded image)
  if (logoPath.startsWith('/') || logoPath.contains('cache') || logoPath.contains('Documents')) {
    // It's a file path - use Image.file()
    try {
      return Image.file(
        File(logoPath),
        width: 80,
        height: 80,
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
      width: 80,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildDefaultLogo();
      },
    );
  }
}

// Helper method for default logo
Widget _buildDefaultLogo() {
  return Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
      borderRadius: BorderRadius.circular(17),
    ),
    child: Icon(
      Icons.business,
      color: isDarkMode ? Colors.white60 : Colors.grey[600],
      size: 32,
    ),
  );
}

@override
Widget build(BuildContext context) {
  final String startupName = widget.startup['name'];
  print('=== DEBUG STARTUP DATA ===');
  print('Startup name: $startupName');
  print('Full startup data: ${widget.startup}');
  print('Description from startup: ${widget.startup['description']}');
  print('Is user submitted: ${widget.startup['isUserSubmitted']}');
  print('Hardcoded description exists: ${startupDescriptions.containsKey(startupName)}');
  print('===========================');
  final String description = startupDescriptions[startupName] ?? widget.startup['description'] ?? 'No description available';
  print('Final description being used: $description');
  final String maker = startupMakers[startupName] ?? 'You'; // Default to 'You' for user-submitted startups
  final List<Map<String, dynamic>> comments = currentComments;

  return Scaffold(
    backgroundColor: backgroundColor,
    resizeToAvoidBottomInset: true,
    body: Stack(
      children: [
        Column(
          children: [
            // Top App Bar with green background
            Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFF8BC34A),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),

                    // Startup Name and Tagline
                    Column(
                      children: [
                        Text(
                          startupName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            widget.startup['tagline'],
                            style: TextStyle(
                              fontSize: 14,
                              color: subtitleColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action Icons Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 28,
                                color: textColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${comments.length}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                size: 32,
                                color: textColor,
                              ),
                              const SizedBox(width: 20),
                              Icon(
                                Icons.send,
                                size: 28,
                                color: textColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Upvote Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isUpvoted) {
                              currentVotes--;
                            } else {
                              currentVotes++;
                            }
                            isUpvoted = !isUpvoted;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isUpvoted ? const Color(0xFFFF5252) : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: isUpvoted ? null : Border.all(color: Colors.grey.shade300, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thumb_up_alt,
                                color: isUpvoted ? Colors.white : Colors.grey.shade600,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'UPVOTE $currentVotes',
                                style: TextStyle(
                                  color: isUpvoted ? Colors.white : Colors.grey.shade700,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Makers Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Makers',
                              style: TextStyle(
                                fontSize: 14,
                                color: subtitleColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              maker,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Discussion Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discussion',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...comments.map((comment) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        comment['name'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        comment['time'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: subtitleColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    comment['comment'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: textColor,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 20,
                                    color: subtitleColor,
                                  ),
                                ],
                              ),
                            )).toList(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),

        // UPDATED: Logo positioned to float half on green bar, half in air
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: _buildStartupLogo(widget.startup['logo']), // UPDATED: Use helper method
              ),
            ),
          ),
        ),
      ],
    ),

    // Bottom comment section
    bottomNavigationBar: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(25),
                  border: isDarkMode
                      ? Border.all(color: Colors.white24)
                      : Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Add a comment',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: subtitleColor,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    suffixIcon: IconButton(
                      onPressed: _addComment,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.green,
                        size: 22,
                      ),
                      splashRadius: 20,
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  onSubmitted: (_) => _addComment(),
                  textInputAction: TextInputAction.send,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
