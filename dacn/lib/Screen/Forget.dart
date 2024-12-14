import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState(); // Tạo trạng thái cho màn hình quên mật khẩu
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _resetPassword() async {

    // Kiểm tra tính hợp lệ của Form trước khi gọi API
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang xử lý...')),
      );

      try {
        final response =
            await http.post(Uri.parse('http://192.168.1.7:8080/api/fogetpass'),
                headers: {
                  'Content-Type': 'application/json',
                },
                body: json.encode({
                  'email': _emailController.text,
                  'newpassword': _passwordController.text,
                }));

        if (response.statusCode == 200) {
          // Thành công, hiển thị thông báo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vui lòng xem mail để xác nhận mật khẩu!')),
          );
        } else {
          final responseBody = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  responseBody['error'] ?? 'Lỗi đặt lại mật khẩu, vui lòng thử lại'),
            ),
          );
        }
      } catch (e) {
        // Lỗi khi thực hiện yêu cầu (timeout, không có kết nối, v.v.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } else {
      // Nếu form không hợp lệ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập đúng thông tin!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CA1AF), Color(0xFFC4E0E5)], // Màu gradient cho nền
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView( // Cho phép cuộn khi nội dung dài
            padding: const EdgeInsets.symmetric(horizontal: 30), // Padding hai bên
            child: Column(
              children: [
                const Text(
                  "Forgot Password?", // Tiêu đề
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Màu chữ
                  ),
                ),
                const SizedBox(height: 20), // Khoảng cách giữa các widget
                const Text(
                  "Enter your email below to receive a password reset link.", // Hướng dẫn
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30), 

                // Trường nhập email
                TextFormField(
                  controller: _emailController, // Gán controller
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Màu nền của trường Input
                    prefixIcon: const Icon(Icons.email, color: Colors.grey), // Biểu tượng
                    hintText: "Email", // Gợi ý cho người dùng
                    hintStyle: TextStyle(color: Colors.grey.shade600), // Màu chữ gợi ý
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Bo tròn góc
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16), // Padding bên trong
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email'; // Thông báo nếu người dùng không nhập email
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return 'Please enter a valid email'; // Kiểm tra định dạng email
                    }
                    return null; // Nếu hợp lệ
                  },
                ),
                const SizedBox(height: 20),

                // Trường nhập mật khẩu (nếu cần thiết)
                TextFormField(
                  controller: _passwordController, // Gán controller
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.password, color: Colors.grey), // Biểu tượng
                    hintText: "New password", // Gợi ý cho người dùng
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Bo tròn góc
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập mật khẩu'; // Thông báo nếu người dùng không nhập mật khẩu
                      }
                      if (value.length < 8) { // Kiểm tra độ dài mật khẩu
                        return 'Mật khẩu trên 8 ký tự'; // Thông báo nếu mật khẩu ngắn
                      }
                      return null; // Nếu hợp lệ
                    },
                ),
                const SizedBox(height: 20),

                // Nút gửi yêu cầu đặt lại mật khẩu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => print("Reset Password Pressed"), // Hành động khi nhấn nút
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16), // Padding cho nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Bo tròn góc cho nút
                      ),
                      backgroundColor: Colors.white, // Màu nền của nút
                    ),
                    child: const Text(
                      "Send Reset Link", // Nội dung của nút
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF4CA1AF), // Màu chữ
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Nút quay lại màn hình đăng nhập
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Quay lại màn hình trước
                  },
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(color: Colors.white70), // Màu chữ cho nút
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
