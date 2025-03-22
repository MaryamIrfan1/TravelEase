import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'booking_screen.dart';


const kDarkBlue = Color(0xFF1E1E41);
const kHighlightColor = Color(0xFF40A3B1);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detail Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlacesScreen(),
    );
  }
}

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Attractions'),
        backgroundColor: kDarkBlue,
      ),
      body: ListView(
        children: const [
          DetailsPage(
            images: ['assets/beach.jpg', 'assets/beach.jpg'],
            title: 'Beach',
            description:
                'Experience the serene beauty of nature. Relax under the warm sun, enjoy crystal-clear waters, and witness the breathtaking sunset.',
            ticketRate: '\Rs.7600',
          ),
          DetailsPage(
            images: ['assets/mountain.jpg', 'assets/mountain.jpg'],
            title: 'City',
            description:
                'Discover breathtaking peaks, lush greenery, and an adventure of a lifetime.',
            ticketRate: '\Rs.5400',
          ),
          DetailsPage(
            images: ['assets/forest.jpg','assets/forest.jpg'],
            title: 'Forest',
            description:
                'Immerse yourself in the tranquility of the forest. Ideal for those seeking peace, bird watching, and a connection with nature.',
            ticketRate: '\Rs.6500',
          ),
          DetailsPage(
            images: ['assets/Mount.jpg','assets/Mount.jpg'],
            title: 'Mountain',
            description:
                'Discover the breathtaking beauty of the world’s second-highest peak. Known for its majestic snow-covered slopes.',
            ticketRate: '\Rs.9800',
          ),
          DetailsPage(
            images: ['assets/desert.jpg','assets/desert.jpg'],
            title: 'Desert',
            description:
                'Experience the mesmerizing beauty of vast sand dunes and magical starry nights.',
            ticketRate: '\Rs.1300',
          ),
        ],
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final List<String> images;
  final String title;
  final String description;
  final String ticketRate;

  const DetailsPage({
    super.key,
    required this.images,
    required this.title,
    required this.description,
    required this.ticketRate,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: SingleChildScrollView(
          // Added to prevent overflow
          child: Column(
            children: [
              // Image Carousel Section
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: CarouselSlider.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index, realIndex) {
                    return Image.asset(
                      images[index],
                      height: size.height * 0.3,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: kHighlightColor,
                          ),
                    ),
                    const SizedBox(height: 10),

                    // Row Section: Rating, Nights, Trip Type
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StylishInfoCard(
                          icon: Iconsax.star1,
                          label: '4.5',
                          iconColor: Colors.amber,
                        ),
                        _StylishInfoCard(
                          icon: Iconsax.moon,
                          label: '2 nights',
                          iconColor: Colors.blue,
                        ),
                        _StylishInfoCard(
                          icon: Iconsax.airplane,
                          label: 'Round Trip',
                          iconColor: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Description Section
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: kHighlightColor,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: kHighlightColor,
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Ticket Rate and Book Now Button Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ticket Rate: $ticketRate",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kHighlightColor,
                                  ),
                        ),

                        // Book Now Button
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to BookingPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BookingPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF40A3B1),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation:
                                    6, // Increased elevation for a more noticeable shadow
                                shadowColor: const Color(0xFF40A3B1),
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1), // Subtle border
                              ),
                              child: const Text(
                                "Book Now",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight
                                      .w600, // Slightly bold for a premium feel
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Back to List Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF40A3B1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.3),
                        side: BorderSide(
                            color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: const Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight:
                              FontWeight.w600, // Slightly bold for premium feel
                        ),
                      ),
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
}

// Stylish Info Card with Border
class _StylishInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _StylishInfoCard({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 2),
            color: Colors.white,
          ),
          child: Icon(
            icon,
            size: 30,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
