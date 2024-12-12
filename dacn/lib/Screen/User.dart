import 'dart:convert';

import 'package:dacn/Model/user_model.dart';
import 'package:dacn/Provider/userProvider.dart';
import 'package:dacn/Screen/EditProfile.dart';
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

  User? user; // Hold the user directly instead of a list
  bool _isLoading = true; // For loading state management

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    const String url = 'http://192.168.1.7:8080/api/users/me'; // Adjust this as necessary

    try {
      final userToken = Provider.of<UserProvider>(context, listen: false).token; // Get the token

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
              builder: (context) => EditProfileScreen(user: user!,)),
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
  final image = Provider.of<UserProvider>(context, listen: false).image;

  if (_isLoading) {
    return const Center(child: CircularProgressIndicator()); // Loading state
  }

  if (user == null) {
    return const Center(child: Text('Không có thông tin người dùng'));
  }

  return Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF6A11CB),
      title: const Text(
        "Thông Tin Người Dùng",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    ),
    body: RefreshIndicator(
      onRefresh: _getUserData,
      child: SingleChildScrollView( // Move the SingleChildScrollView here
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    // User Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 46,
                        backgroundImage: user?.image != null 
                          ? NetworkImage(user!.image) 
                          : const AssetImage('assets/Images/User.jpg'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user!.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user!.name,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thông Tin Tài Khoản",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A11CB),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Color(0xFF6A11CB)),
                      title: const Text("Họ Tên"),
                      subtitle: Text(user!.name),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: const Icon(Icons.email, color: Color(0xFF6A11CB)),
                      title: const Text("Email"),
                      subtitle: Text(user!.email), // Ensure you're referencing correct field
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: const Icon(Icons.phone, color: Color(0xFF6A11CB)),
                      title: const Text("Số Điện Thoại"),
                      subtitle: Text(user!.phone), // Ensure you're referencing correct field
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: const Icon(Icons.home, color: Color(0xFF6A11CB)),
                      title: const Text("Địa Chỉ"),
                      subtitle: Text(user!.address), // Ensure you're referencing correct field
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Actions Section
                  const Text(
                    "Thao Tác",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A11CB),
                    ),
                  ),
                  const SizedBox(height: 10),
                  UserWidget.actionButton(
                    icon: Icons.edit,
                    label: "Chỉnh Sửa Thông Tin",
                    onTap: _navigateToEditProfile,  // Adjusted to use _navigateToEditProfile
                  ),
                  UserWidget.actionButton(
                    icon: Icons.logout,
                    label: "Đăng Xuất",
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
    ),
  );
}

}