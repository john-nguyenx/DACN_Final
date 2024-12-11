import 'package:dacn/Screen/EditProfile.dart';
import 'package:dacn/Widget/User.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
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
                child: Column(
                  children: [
                    // User Avatar
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: const CircleAvatar(
                        radius: 56,
                        backgroundImage: NetworkImage(
                          'https://www.w3schools.com/w3images/avatar2.png', // Demo avatar URL
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                    },
                  ),
                  UserWidget.actionButton(
                    icon: Icons.logout,
                    label: "Log Out",
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
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