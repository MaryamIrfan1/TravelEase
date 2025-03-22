import 'package:flutter/material.dart';
import 'home_screen.dart'; // Ensure you have HomeScreen imported correctly

class UserScreen extends StatelessWidget {
  final String username;
  //final String email;

  // Constructor to pass username and email
  UserScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF40A3B1), // Teal background color for all sides
      appBar: AppBar(
        backgroundColor: Color(0xFF40A3B1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Color(0xFF40A3B1), width: 5), // Bolder teal-colored borders
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'User Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF40A3B1),
                      ),
                    ),
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFF40A3B1),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/cute-girl-cartoon-character-icon-illustration-icon-concept-isolated-premium-flat-000001-vector.jpg', // Replace with your image path
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      username, // Display dynamic username
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF40A3B1),
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to HomeScreen when logout button is pressed
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF40A3B1),
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
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
