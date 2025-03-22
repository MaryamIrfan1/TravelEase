import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'detail_screen.dart';
import 'user_screen.dart';

const kTealColor = Color(0xFF40A3B1);
const kBlueTextColor = Color(0xff035997);
const kDarkBlue = Color(0xFF0B0B23);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign In",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String username = usernameController.text;
                if (username.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacesScreen(username: username),
                    ),
                  );
                }
              },
              child: const Text("Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}

class PlacesScreen extends StatefulWidget {
  final String username;

  const PlacesScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  int selectedPage = 0;
  final List<String> categories = [
    'Forest',
    'Mountains',
    'Beach',
    'City',
    'Desert'
  ];
  List<String> filteredCategories =
  []; // To store filtered categories based on search query
  final TextEditingController searchController =
  TextEditingController(); // Controller for search field

  @override
  void initState() {
    super.initState();
    filteredCategories =
        categories; // Initialize filtered categories with all categories
  }

  void _filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((category) =>
          category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          Container(
            color: kTealColor,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${widget.username}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Let’s Travel ",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E41),
                        ),
                      ),
                      TextSpan(
                        text: "you in",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                // Search Bar
                TextField(
                  controller: searchController,
                  onChanged:
                  _filterCategories, // Update filtered categories on search input change
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search for places",
                    prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      filteredCategories.length,
                          (index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the details screen based on selected category
                            // Define a map for categories to corresponding images
                            final Map<String, String> categoryImages = {
                              'Forest': 'assets/forest.jpg',
                              'Mountains': 'assets/Mount.jpg',
                              'Beach': 'assets/beach.jpg',
                              'City':
                              'assets/mountain.jpg', // Add the appropriate image for 'City'
                              'Desert': 'assets/desert.jpg',
                            };

// Modify the Navigator.push logic
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  title: filteredCategories[
                                  index], // Provide the title dynamically
                                  images: [
                                    categoryImages[filteredCategories[index]] ??
                                        'assets/forest.jpg', // Default to 'assets/forest.jpg' if no match is found
                                  ],
                                  description:
                                  'Explore a range of beautiful destinations offer vibrant city life, and rich cultural experiences. Whether its relaxing by the beach or hiking through lush forests, each place offers something unique for every traveler.',

                                  ticketRate:
                                  '\Rs.1300', // Provide a ticket rate
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDarkBlue,
                            foregroundColor: kBlueTextColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            filteredCategories[index],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recommendations",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        // Text(
                        //   "See all",
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     color: kBlueTextColor,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to details page for Beach
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DetailsPage(
                                    images: [
                                      'assets/beach.jpg',
                                      'assets/beach.jpg'
                                    ],
                                    title: 'Beach',
                                    description:
                                    'Experience the serene beauty of nature. Relax under the warm sun, enjoy crystal-clear waters, and witness the breathtaking sunset.',
                                    ticketRate: '\Rs.7600',
                                  ),
                                ),
                              );
                            },
                            child: const RecommendationCard(
                              image: 'assets/beach.jpg',
                              label: 'Beach',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to details page for City
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DetailsPage(
                                    images: [
                                      'assets/mountain.jpg',
                                      'assets/mountain.jpg'
                                    ],
                                    title: 'City',
                                    description:
                                    'Discover breathtaking peaks, lush greenery, and an adventure of a lifetime.',
                                    ticketRate: '\Rs.5400',
                                  ),
                                ),
                              );
                            },
                            child: const RecommendationCard(
                              image: 'assets/mountain.jpg',
                              label: 'City',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to details page for Forest
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DetailsPage(
                                    images: ['assets/forest.jpg'],
                                    title: 'Forest',
                                    description:
                                    'Immerse yourself in the tranquility of the forest. Ideal for those seeking peace, bird watching, and a connection with nature.',
                                    ticketRate: '\Rs.1300',
                                  ),
                                ),
                              );
                            },
                            child: const RecommendationCard(
                              image: 'assets/forest.jpg',
                              label: 'Forests',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Nearby",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailsPage(
                              images: ['assets/Mount.jpg'],
                              title: 'Mountain',
                              description:
                              'Discover the breathtaking beauty of the world’s second-highest peak. Known for its majestic snow-covered slopes.',
                              ticketRate: '\Rs.9800',
                            ),
                          ),
                        );
                      },
                      child: const NearbyCard(
                        image: 'assets/Mount.jpg',
                        distance: '398 km',
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailsPage(
                              images: ['assets/mountain.jpg'],
                              title: 'City',
                              description:
                              'Discover the breathtaking beauty of the world’s second-highest peak. Known for its majestic snow-covered slopes.',
                              ticketRate: '\Rs.5400',
                            ),
                          ),
                        );
                      },
                      child: const NearbyCard(
                        image: 'assets/mountain.jpg',
                        distance: '120 km',
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailsPage(
                              images: ['assets/forest.jpg'],
                              title: 'Forest',
                              description:
                              'Immerse yourself in the tranquility of the forest. Ideal for those seeking peace, bird watching, and a connection with nature.',
                              ticketRate: '\Rs.6500',
                            ),
                          ),
                        );
                      },
                      child: const NearbyCard(
                        image: 'assets/forest.jpg',
                        distance: '120 km',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // recommedation Section
        ],
      ),
      bottomNavigationBar: Container(
  decoration: const BoxDecoration(
    color: kDarkBlue,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  ),
  child: BottomNavigationBar(
    backgroundColor: Colors.transparent,
    currentIndex: selectedPage,
    onTap: (index) {
      setState(() {
        selectedPage = index;
      });

      // Check if the user icon is tapped (index 1)
      if (index == 1) {
        // Navigate to UserProfileScreen when user icon is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserScreen(username: widget.username),
          ),
        );
      }
    },
    items: [
      BottomNavigationBarItem(
        icon: GestureDetector(
          onTap: () {
            setState(() {
              selectedPage = 0; // Ensure this corresponds to the Places screen's index
            });
          },
          child: Icon(Iconsax.home, size: 30),
        ),
        label: '',
      ),

      // Uncomment or remove the following items based on your needs
      // BottomNavigationBarItem(
      //   icon: Icon(Iconsax.search_normal, size: 30),
      //   label: '',
      // ),
      // BottomNavigationBarItem(
      //   icon: Icon(Iconsax.ticket, size: 30),
      //   label: '',
      // ),

      BottomNavigationBarItem(
        icon: Icon(Iconsax.user, size: 30),
        label: '',
      ),
    ],
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white54,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
  ),
),
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final String image;
  final String label;

  const RecommendationCard({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NearbyCard extends StatelessWidget {
  final String image;
  final String distance;

  const NearbyCard({required this.image, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  distance,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}