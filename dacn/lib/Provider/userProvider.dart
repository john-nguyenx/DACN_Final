import 'dart:convert'; // Nhập thư viện để xử lý JSON
import 'dart:io'; // Nhập thư viện cho các thao tác hệ thống
import 'package:flutter/material.dart'; // Nhập thư viện Flutter
import 'package:shared_preferences/shared_preferences.dart'; // Nhập thư viện để lưu trữ dữ liệu

class UserProvider with ChangeNotifier {
  String? _name; // Biến lưu tên người dùng
  String? _email; // Biến lưu email người dùng
  String? _image; // Biến lưu đường dẫn ảnh người dùng
  String? _token; // Biến lưu token xác thực

  // Getters
  String? get name => _name; // Lấy tên người dùng
  String? get email => _email; // Lấy email người dùng
  String? get image => _image; // Lấy đường dẫn ảnh người dùng
  String? get token => _token; // Lấy token xác thực

  // Phương thức để thiết lập thông tin người dùng
  Future<void> setUserDetails({
    required String name,
    required String email,
    required String? image,
    required String token,
  }) async {
    _name = name; // Lưu tên người dùng
    _email = email; // Lưu email người dùng
    _image = image; // Lưu đường dẫn ảnh người dùng
    _token = token; // Lưu token xác thực

    // Lưu thông tin người dùng vào SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode({
      'name': name,
      'email': email,
      'image': image,
      'token': token,
    }));

    // Thông báo cho UI về sự thay đổi dữ liệu
    notifyListeners();
  }

  // Phương thức để tải thông tin người dùng đã lưu (nếu có)
  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final savedUser = json.decode(prefs.getString('user')!) as Map<String, dynamic>; // Giải mã dữ liệu JSON
      _name = savedUser['name']; // Lấy tên người dùng
      _email = savedUser['email']; // Lấy email người dùng
      _image = savedUser['image'] ?? ''; // Lấy ảnh người dùng (nếu không có, trở về chuỗi rỗng)
      _token = savedUser['token']; // Lấy token xác thực

      notifyListeners(); // Thông báo cho UI về sự thay đổi dữ liệu
    }
  }

  // Phương thức để cập nhật đường dẫn ảnh của người dùng
  void updateImage(String newImagePath) async {
    _image = newImagePath; // Cập nhật đường dẫn ảnh

    // Lưu lại vào SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final Map<String, dynamic> savedUser = json.decode(prefs.getString('user')!) as Map<String, dynamic>;
      savedUser['image'] = newImagePath; // Cập nhật đường dẫn ảnh trong dữ liệu người dùng
      await prefs.setString('user', json.encode(savedUser)); // Lưu lại dữ liệu đã cập nhật
    }

    notifyListeners(); // Thông báo cho UI về sự thay đổi dữ liệu
  }

  // Phương thức để xóa thông tin người dùng
  Future<void> clearUserDetails() async {
    _name = null; // Đặt lại tên
    _email = null; // Đặt lại email
    _image = null; // Đặt lại đường dẫn ảnh
    _token = null; // Đặt lại token

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user'); // Xóa thông tin người dùng trong SharedPreferences

    notifyListeners(); // Thông báo cho UI về sự thay đổi dữ liệu
  }

  // Kiểm tra xem người dùng đã đăng nhập hay chưa
  bool get isLoggedIn => _token != null && _token!.isNotEmpty; // Trả về true nếu token không null và không rỗng
}
