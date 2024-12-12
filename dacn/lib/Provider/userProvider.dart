import 'dart:convert'; // For JSON parsing
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _name;
  String? _email;
  String? _image;
  String? _token;

  // Getters
  String? get name => _name;
  String? get email => _email;
  String? get image => _image;
  String? get token => _token;

  // Method to set user details
  Future<void> setUserDetails({
    required String name,
    required String email,
    required String? image,
    required String token,
  }) async {
    _name = name;
    _email = email;
    _image = image;
    _token = token;

    // Persist user data in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode({
      'name': name,
      'email': email,
      'image': image,
      'token': token,
    }));

    // Notify listeners for updates in the UI
    notifyListeners();
  }

  // Method to load saved user details (if any)
  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final savedUser = json.decode(prefs.getString('user')!) as Map<String, dynamic>;
      _name = savedUser['name'];
      _email = savedUser['email'];
      _image = savedUser['image'] ?? '';
      _token = savedUser['token'];

      notifyListeners();
    }
  }

  void updateImage(String newImagePath) async {
  _image = newImagePath;

  // Lưu vào SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('user')) {
    final Map<String, dynamic> savedUser = json.decode(prefs.getString('user')!) as Map<String, dynamic>;
    savedUser['image'] = newImagePath; // Cập nhật đường dẫn ảnh trong dữ liệu người dùng
    await prefs.setString('user', json.encode(savedUser));
  }

  notifyListeners(); 
}


  Future<void> clearUserDetails() async {
    _name = null;
    _email = null;
    _image = null;
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');


    notifyListeners();
  }

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
}
