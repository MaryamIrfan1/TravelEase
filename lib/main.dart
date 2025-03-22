import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:travel/pages/home_screen.dart';
import 'package:travel/pages/signin_screen.dart'
    as signin; // Add prefix for SignInScreen
import 'package:travel/pages/signup_screen.dart';
import 'package:travel/pages/detail_screen.dart' as detailScreen;
import 'package:travel/pages/places_screen.dart' as placesScreen;
import 'package:travel/pages/booking_screen.dart'; // Import BookingScreen
import 'package:flutter_map/flutter_map.dart'; // Add this import
import 'package:latlong2/latlong.dart'; // Add this import for latlong2

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for web and non-web platforms
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "//",
            authDomain: "travelapp-bb035.firebaseapp.com",
            projectId: "travelapp-bb035",
            storageBucket: "travelapp-bb035.firebasestorage.app",
            messagingSenderId: "768948766530",
            appId: "1:768948766530:web:d9a24b6e627ee923612adb",
            measurementId: "G-WR7VFY6LGV"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/signin': (context) =>
            const signin.SignInScreen(), // Use prefixed SignInScreen
        '/signup': (context) => SignUpScreen(),
        '/places': (context) => placesScreen.PlacesScreen(username: 'User'),
        '/map': (context) => MapScreen(), // Add a new route for the map screen
        '/booking': (context) =>
            const BookingPage(), // Add new route for booking
      },
    );
  }
}

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final Map<String, LatLng> _locationCoordinates = {
    "beach": LatLng(33.6844, 73.0978), // Rawal Lake, Islamabad (water area)
    "mountain": LatLng(33.7385, 73.0667), // Margalla Hills
    "city": LatLng(33.6844, 73.0479), // Islamabad City Center
    "desert": LatLng(
        33.6155, 73.0791), // Chak Shahzad, Islamabad (open, sandy terrain)
    "forest": LatLng(33.7506, 73.0741), // Trail 5 Forest Area, Margalla Hills
  };

  @override
  Widget build(BuildContext context) {
    // Providing a default location in case the selected key is null
    String selectedLocation = "beach"; // Default location is "beach"
    LatLng initialLocation =
        _locationCoordinates[selectedLocation] ?? LatLng(33.6844, 73.0978);

    return Scaffold(
      appBar: AppBar(title: const Text("MapTiler Map")),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedLocation,
            items: _locationCoordinates.keys.map((String key) {
              return DropdownMenuItem<String>(
                value: key,
                child: Text(key),
              );
            }).toList(),
            onChanged: (String? newValue) {
              selectedLocation = newValue!;
              initialLocation = _locationCoordinates[selectedLocation] ??
                  LatLng(33.6844, 73.0978);
            },
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: initialLocation,
                initialZoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.maptiler.com/maps/basic/256/{z}/{x}/{y}.png?key=8rE9XCNNU7GoAdJmnZuQ', // MapTiler URL with your API key
                  additionalOptions: {'subdomains': 'a,b,c'},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
