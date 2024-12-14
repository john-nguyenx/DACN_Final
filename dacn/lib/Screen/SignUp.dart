import 'package:flutter/material.dart'; // Nhập thư viện Flutter

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2575FC), Color(0xFF6A11CB)], // Màu gradient cho nền
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView( // Cho phép cuộn nếu nội dung dài
            padding: const EdgeInsets.symmetric(horizontal: 30), // Padding cho hai bên
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các phần tử
              children: [
                // Logo hoặc Tiêu đề
                Container(
                  margin: const EdgeInsets.only(bottom: 40), // Khoảng cách dưới tiêu đề
                  child: const Text(
                    "Create Account", // Tiêu đề cho màn hình đăng ký
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold, // Chữ đậm
                      color: Colors.white, // Màu chữ
                    ),
                  ),
                ),
                // Trường nhập họ tên
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Màu nền trường nhập liệu
                    prefixIcon: const Icon(Icons.person, color: Colors.grey), // Biểu tượng cho trường họ tên
                    hintText: "Full Name", // Gợi ý cho người dùng
                    hintStyle: TextStyle(color: Colors.grey.shade600), // Màu chữ gợi ý
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Bo tròn góc
                      borderSide: BorderSide.none, // Không có đường viền
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16), // Padding bên trong
                  ),
                ),
                const SizedBox(height: 20), // Khoảng cách giữa các trường

                // Trường nhập email
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Màu nền trường nhập liệu
                    prefixIcon: const Icon(Icons.email, color: Colors.grey), // Biểu tượng cho trường email
                    hintText: "Email", // Gợi ý cho người dùng
                    hintStyle: TextStyle(color: Colors.grey.shade600), // Màu chữ gợi ý
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Bo tròn góc
                      borderSide: BorderSide.none, // Không có đường viền
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16), // Padding bên trong
                  ),
                ),
                const SizedBox(height: 20), // Khoảng cách giữa các trường

                // Trường nhập mật khẩu
                TextField(
                  obscureText: true, // Làm ẩn mật khẩu đã nhập
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Màu nền trường nhập liệu
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey), // Biểu tượng cho trường mật khẩu
                    hintText: "Password", // Gợi ý cho người dùng
                    hintStyle: TextStyle(color: Colors.grey.shade600), // Màu chữ gợi ý
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Bo tròn góc
                      borderSide: BorderSide.none, // Không có đường viền
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16), // Padding bên trong
                  ),
                ),
                const SizedBox(height: 20), // Khoảng cách giữa các trường

                // Nút đăng ký
                SizedBox(
                  width: double.infinity, // Nút rộng hết chiều ngang
                  child: ElevatedButton(
                    onPressed: () => print("Sign Up Pressed"), // Hành động nhấn nút
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16), // Padding cho nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Bo tròn góc cho nút
                      ),
                      backgroundColor: Colors.white, // Màu nền nút
                    ),
                    child: const Text(
                      "Sign Up", // Nội dung của nút
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF6A11CB), // Màu chữ
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Khoảng cách dưới nút

                // Phần quay lại màn hình đăng nhập
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Căn giữa cho hàng
                  children: [
                    const Text(
                      "Already have an account?", // Văn bản hỏi người dùng về tài khoản
                      style: TextStyle(color: Colors.white70), // Màu chữ
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Quay về màn hình trước đó
                      },
                      child: const Text(
                        "Log In", // Nội dung nút "Đăng nhập"
                        style: TextStyle(
                          color: Colors.white, // Màu chữ
                          fontWeight: FontWeight.bold,
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
    );
  }
}
