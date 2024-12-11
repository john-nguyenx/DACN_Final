import 'dart:convert';
import 'package:dacn/Provider/userProvider.dart';
import 'package:dacn/Screen/EditProfile.dart';
import 'package:dacn/Model/user_model.dart';
import 'package:dacn/Widget/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }


  Future<void> _getUserData() async {
    const String url = 'http://192.168.1.7:8080/api/users/me'; // Adjust this as necessary

    try {
      final userToken = Provider.of<UserProvider>(context, listen: false).token;

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Include the token
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          user = User.fromJson(jsonData);   // Map to a User instance directly
          _isLoading = false; // Stop loading
        });
      } else {
        _showErrorSnackbar('Unable to fetch data: ${response.reasonPhrase}');
        setState(() {
          _isLoading = false; // Stop loading on error
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
      _showErrorSnackbar('Error fetching user data: $error');
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _navigateToEditProfile() async {
    if (user != null) {
      final updatedUser = await Navigator.push<User>(
          context,
          MaterialPageRoute(
              builder: (context) => EditProfileScreen(user: user!)),
      );

      if (updatedUser != null) {
        setState(() {
          user = updatedUser; // Cập nhật thông tin người dùng
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF6A11CB),
        title: const Text(
          "User Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: const Column(
                  children: [
                    // User Avatar
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundImage: NetworkImage(
                          'https://www.w3schools.com/w3images/avatar2.png', // Demo avatar URL
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "johndoe@email.com",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Information Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Account Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A11CB),
                    ),
                  ),
                  const SizedBox(height: 20),
                  UserWidget.infoRow("Full Name", "John Doe"),
                  UserWidget.infoRow("Email", "johndoe@email.com"),
                  UserWidget.infoRow("Phone", "+1 123 456 789"),
                  UserWidget.infoRow("Address", "123, Sunny Street, San Francisco"),
                  const SizedBox(height: 30),
                  // Actions Section
                  const Text(
                    "Actions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A11CB),
                    ),
                  ),
                  const SizedBox(height: 10),
                  UserWidget.actionButton(
                    icon: Icons.edit,
                    label: "Edit Profile",
                    onTap: () {
                       _navigateToEditProfile;
                    },
                  ),
                  UserWidget.actionButton(
                    icon: Icons.logout,
                    label: "Log Out",
                    onTap: () {
                      Provider.of<UserProvider>(context, listen: false).clearUserDetails();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}