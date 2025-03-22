import 'package:flutter/material.dart';
import 'dart:developer';
import 'auth_services.dart';
import 'user_screen.dart'; // Corrected to import UserScreen
import 'signin_screen.dart' as signin; // Import the Sign-In screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background layers
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.white,
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            height: MediaQuery.of(context).size.height * 0.7,
            color: const Color(0xFF40A3B1),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF40A3B1),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        "Full Name",
                        "Enter your full name",
                        _nameController,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        "Email",
                        "Enter your email",
                        _emailController,
                        inputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        "Password",
                        "Enter your password",
                        _passwordController,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: _isAgree,
                            onChanged: (value) {
                              setState(() {
                                _isAgree = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF40A3B1),
                          ),
                          const Expanded(
                            child: Text(
                              "I agree to the processing of personal data",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading || !_isAgree
                            ? null
                            : () => _signup(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xFF40A3B1),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => signin.SignInScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF40A3B1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller,
      {bool isPassword = false, TextInputType inputType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF40A3B1),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "$label is required";
            }
            if (label == "Email" && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
              return "Enter a valid email";
            }
            if (label == "Password" && value.length < 6) {
              return "Password must be at least 6 characters";
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _signup(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _auth.createUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null) {
        log("User created successfully.");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                signin.SignInScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-up failed. Please try again.')),
        );
      }
    } catch (e) {
      log('Error during sign-up: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-up failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
