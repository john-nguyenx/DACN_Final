import 'package:dacn/Screen/Main.dart'; // Nhập màn hình chính
import 'package:dacn/Widget/messLogin.dart'; // Nhập widget thông báo đăng nhập
import 'package:flutter/material.dart'; // Nhập thư viện Flutter
import 'dart:async'; // Nhập thư viện cho các tác vụ bất đồng bộ
import 'dart:developer' as developer; // Nhập thư viện để ghi nhật ký
import 'package:connectivity_plus/connectivity_plus.dart'; // Nhập thư viện kiểm tra kết nối
import 'package:flutter/services.dart'; // Nhập thư viện để sử dụng các dịch vụ của hệ thống
import 'dart:convert'; // Nhập thư viện để chuyển đổi dữ liệu JSON
import 'package:http/http.dart' as http; // Nhập thư viện HTTP
import 'package:provider/provider.dart'; // Nhập thư viện Provider để quản lý trạng thái

import '../Provider/userProvider.dart'; // Nhập provider cho người dùng

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState(); // Tạo trạng thái cho màn hình đăng nhập
}

class _SignInScreenState extends State<SignInScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none]; // Trạng thái kết nối
  final Connectivity _connectivity = Connectivity(); // Đối tượng kiểm tra kết nối

  final TextEditingController _emailController = TextEditingController(); // Controller cho trường email
  final TextEditingController _passwordController = TextEditingController(); // Controller cho trường mật khẩu

  bool _isLoading = false; // Trạng thái loading

  final loginWidget = LoginWidget(); // Khởi tạo widget thông báo đăng nhập
  final _formKey = GlobalKey<FormState>(); // Khóa cho form

  @override
  void initState() {
    super.initState();
    initConnectivity(); // Gọi hàm kiểm tra kết nối khi khởi tạo
  }

  // Hàm kiểm tra kết nối
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result; // Khai báo biến trạng thái kết nối
    try {
      result = await _connectivity.checkConnectivity(); // Kiểm tra trạng thái kết nối
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e); // Ghi lại lỗi nếu không kiểm tra kết nối được
      return;
    }

    if (!mounted) {
      return Future.value(null); // Nếu không còn mounted, không làm gì cả
    }
    return _updateConnectionStatus(result); // Cập nhật trạng thái kết nối
  }

  // Hàm cập nhật trạng thái kết nối
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result; // Cập nhật trạng thái kết nối
    });
    if (_connectionStatus.contains(ConnectivityResult.none)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text('Không có kết nối')))); // Thông báo không có kết nối
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text('Đã có kết nối')))); // Thông báo đã có kết nối
    }
  }

  // Hàm xử lý đăng nhập
  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) { // Kiểm tra tính hợp lệ của form
      String email = _emailController.text.trim(); // Lấy email
      String password = _passwordController.text.trim(); // Lấy mật khẩu

      setState(() {
        _isLoading = true; // Đánh dấu trạng thái loading
      });

      try {
        // Gửi yêu cầu đăng nhập đến server
        final response = await http.post(
          Uri.parse('http://192.168.1.7:8080/api/login'), // Địa chỉ API
          headers: {'Content-Type': 'application/json'}, // Thiết lập header là JSON
          body: json.encode({'email': email, 'password': password}), // Chuyển đổi sang định dạng JSON
        );

        // Kiểm tra mã trạng thái
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body); // Giải mã phản hồi JSON
          final userData = jsonResponse['user']; // Lấy dữ liệu người dùng
          final String token = jsonResponse['token']; // Lấy token xác thực

          // Cập nhật thông tin người dùng vào Provider
          Provider.of<UserProvider>(context, listen: false).setUserDetails(
            name: userData['name'],
            email: userData['email'],
            image: userData['image'],
            token: token,
          );

          // Chuyển hướng đến màn hình chính
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          // Nếu đăng nhập thất bại, hiển thị thông báo lỗi
          final errorResponse = json.decode(response.body);
          String errorMessage = errorResponse['message'] ?? 'Đăng nhập thất bại';
          loginWidget.showSuccessMessage(errorMessage, context);
        }
      } catch (e) {
        // Xuất thông báo lỗi khi có lỗi xảy ra
        loginWidget.showSuccessMessage('Đã xảy ra lỗi', context);
      } finally {
        setState(() {
          _isLoading = false; // Kết thúc trạng thái loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], // Màu gradient cho nền
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView( // Cho phép cuộn khi nội dung dài
            padding: const EdgeInsets.symmetric(horizontal: 30), // Padding cho hai bên
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: const Text(
                    "Welcome Back!", // Tiêu đề chào mừng
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Màu chữ
                    ),
                  ),
                ),
                // Input fields
                Form(
                  key: _formKey, // Gán khóa cho form
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController, // Gán controller
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Màu nền cho trường nhập liệu
                          prefixIcon: const Icon(Icons.email, color: Colors.grey), // Biểu tượng email
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
                            return 'Please enter your email'; // Thông báo nếu không nhập email
                          }
                          if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                            return 'Please enter a valid email'; // Kiểm tra định dạng email
                          }
                          return null; // Nếu hợp lệ
                        },
                      ),
                      const SizedBox(height: 20), // Khoảng cách giữa các trường

                      TextFormField(
                        controller: _passwordController, // Gán controller
                        obscureText: true, // Làm ẩn mật khẩu đã nhập
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Màu nền cho trường nhập liệu
                          prefixIcon: const Icon(Icons.lock, color: Colors.grey), // Biểu tượng mật khẩu
                          hintText: "Password", // Gợi ý cho người dùng
                          hintStyle: TextStyle(color: Colors.grey.shade600), // Màu chữ gợi ý
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30), // Bo tròn góc
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16), // Padding bên trong
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nhập mật khẩu'; // Thông báo nếu không nhập mật khẩu
                          }
                          if (value.length < 8) {
                            return 'Mật khẩu trên 8 ký tự'; // Thông báo nếu mật khẩu quá ngắn
                          }
                          return null; // Nếu hợp lệ
                        },
                      ),
                    ],
                  ),
                ),

                // Quên mật khẩu
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgot'), // Chuyển đến màn hình quên mật khẩu
                    child: const Text(
                      "Forgot Password?", // Tên nút "Quên mật khẩu"
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Nút đăng nhập
                SizedBox(
                  width: double.infinity, // Nút rộng hết chiều ngang
                  child: ElevatedButton(
                    onPressed: () => _signIn(), // Gọi hàm đăng nhập
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16), // Padding cho nút
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Bo tròn góc cho nút
                      ),
                      backgroundColor: Colors.white, // Màu nền của nút
                    ),
                    child: const Text(
                      "Log In", // Nội dung của nút
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF2575FC), // Màu chữ
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Phân cách
                const Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.white54, thickness: 1), // Đường phân cách
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR", // Giữa các phần
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.white54, thickness: 1), // Đường phân cách
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Nút đăng nhập bằng mạng xã hội
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => print("Google Login Pressed"), // Hành động khi nhấn nút Google
                      icon: const Icon(Icons.g_mobiledata, size: 40, color: Colors.white), // Biểu tượng Google
                    ),
                    const SizedBox(width: 20), // Khoảng cách giữa hai biểu tượng
                    IconButton(
                      onPressed: () => print("Facebook Login Pressed"), // Hành động khi nhấn nút Facebook
                      icon: const Icon(Icons.facebook, size: 40, color: Colors.white), // Biểu tượng Facebook
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Văn bản đăng ký
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?", // Hỏi người dùng về tài khoản
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'), // Chuyển đến màn hình đăng ký
                      child: const Text(
                        "Sign Up", // Tên nút đăng ký
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
