import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Ensure to include this package for Iconsax
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // For map coordinates
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookingPage(),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int selectedPage = 0;
  int _travellerCount = 1;
  DateTime? _departureDate;
  DateTime? _returnDate;

  // Controllers for text fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();

  // Base ticket rate
  final int baseTicketRate = 9800;

  // Get total ticket rate
  int get totalTicketRate => baseTicketRate * _travellerCount;

  // Validate fields
  bool _areFieldsValid() {
    return _nameController.text.isNotEmpty &&
        _mobileController.text.isNotEmpty &&
        _mobileController.text.length == 11 &&
        _fromController.text.isNotEmpty &&
        _toController.text.isNotEmpty &&
        _departureDate != null &&
        _returnDate != null;
  }

  // Mapping of location types to coordinates
  final Map<String, LatLng> _locationCoordinates = {
    "beach": LatLng(33.6844, 73.0978), // Rawal Lake, Islamabad (water area)
    "mountain": LatLng(33.7385, 73.0667), // Margalla Hills
    "city": LatLng(33.6844, 73.0479), // Islamabad City Center
    "desert": LatLng(33.6155, 73.0791), // Chak Shahzad, Islamabad (open, sandy terrain)
    "forest": LatLng(33.7506, 73.0741), // Trail 5 Forest Area, Margalla Hills
  };

  // Show SnackBar message
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message == "Your flight is booked!"
            ? Colors.cyan[900]
            : Colors.red[800],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        picked != (isDeparture ? _departureDate : _returnDate)) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  // MapTiler URL for tiles
  final String _mapTilerUrl =
      "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=8rE9XCNNU7GoAdJmnZuQ";

  // Initial position for the map (Islamabad coordinates)
  //final LatLng _initialPosition = LatLng(33.6844, 73.0479);
  LatLng _selectedLocation =LatLng(33.6844, 73.0978); // Default to beach location

  // Method to update the map location based on the "To" location
  void _updateLocation() {
    setState(() {
      _selectedLocation =
          _locationCoordinates[_toController.text.toLowerCase()] ??
              _locationCoordinates['beach']!;
    });
  }

  // Save data to Firestore
  Future<void> _saveBooking() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Save the data to Firestore
      await firestore.collection('Ticket_Detail').add({
        'name': _nameController.text,
        'mobile': _mobileController.text,
        'from': _fromController.text,
        'to': _toController.text,
        'departureDate': _departureDate?.toIso8601String(),
        'returnDate': _returnDate?.toIso8601String(),
        'travellerCount': _travellerCount,
        'totalTicketRate': totalTicketRate,
      });

      _showMessage("Your flight is booked!");
    } catch (e) {
      print("Error saving data: $e");
      _showMessage("Failed to book flight. Try again!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
              child: const Text(
                'Book your Tickets',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF40A3B1),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF40A3B1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22.0),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Field
                        Row(
                          children: [
                            Icon(Icons.person, color: Color(0xFF40A3B1)),
                            SizedBox(width: 10),
                            Text('Name', style: TextStyle(fontSize: 18)),
                            Spacer(),
                            Expanded(
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your name',
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // Mobile Number Field
                        Row(
                          children: [
                            Icon(Icons.phone, color: Color(0xFF40A3B1)),
                            SizedBox(width: 10),
                            Text('Mobile Number',
                                style: TextStyle(fontSize: 18)),
                            Spacer(),
                            Expanded(
                              child: TextField(
                                controller: _mobileController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Enter 11-digit mobile number',
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // "From" Location Field
                        Row(
                          children: [
                            Icon(Icons.flight_takeoff,
                                color: Color(0xFF40A3B1)),
                            SizedBox(width: 10),
                            Text('From', style: TextStyle(fontSize: 18)),
                            Spacer(),
                            Expanded(
                              child: TextField(
                                controller: _fromController,
                                decoration: InputDecoration(
                                  hintText: 'Enter location',
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // "To" Location Field
                        Row(
                          children: [
                            Icon(Icons.flight_land, color: Color(0xFF40A3B1)),
                            SizedBox(width: 10),
                            Text('To', style: TextStyle(fontSize: 18)),
                            Spacer(),
                            Expanded(
                              child: TextField(
                                controller: _toController,
                                onChanged: (value) {
                                  _updateLocation(); // Update the location when the text changes
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter location',
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text('Departure',
                                style: TextStyle(fontSize: 18)),
                            const Spacer(),
                            TextButton(
                              onPressed: () => _selectDate(context, true),
                              child: Text(
                                _departureDate != null
                                    ? DateFormat('dd MMM yyyy')
                                        .format(_departureDate!)
                                    : 'Select Date',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text('Return',
                                style: TextStyle(fontSize: 18)),
                            const Spacer(),
                            TextButton(
                              onPressed: () => _selectDate(context, false),
                              child: Text(
                                _returnDate != null
                                    ? DateFormat('dd MMM yyyy')
                                        .format(_returnDate!)
                                    : 'Select Date',
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text('Travellers',
                                style: TextStyle(fontSize: 18)),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (_travellerCount > 1) {
                                    _travellerCount--; // Decrease the count but ensure it doesn't go below 1
                                  }
                                });
                              },
                            ),
                            Text(
                              '$_travellerCount Person${_travellerCount > 1 ? 's' : ''}',
                              style: const TextStyle(fontSize: 17),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _travellerCount++; // Increase the count
                                });
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text('Total Ticket Rate',
                                style: TextStyle(fontSize: 18)),
                            const Spacer(),
                            Text(
                              'Rs. $totalTicketRate',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_areFieldsValid()) {
                              _saveBooking(); // Save booking to Firestore
                            } else {
                              _showMessage("Please fulfill all fields!");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF40A3B1),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Click here to Book',
                              style:
                                  TextStyle(fontSize: 21, color: Colors.white),
                            ),
                          ),
                        ),

                        // Map Section
                        // Map section
                        const SizedBox(height: 30),
                        Text(
                          'Map View of Your Destination',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 250,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter:
                                  _selectedLocation, // Center the map on the selected location
                              initialZoom: 10.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: _mapTilerUrl,
                                additionalOptions: {
                                  'key':
                                      '8rE9XCNNU7GoAdJmnZuQ', // MapTiler API key
                                },
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point:
                                        _selectedLocation, // Marker at the updated location
                                    width: 80.0,
                                    height: 80.0,
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 40,
                                      color: Colors.red,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
