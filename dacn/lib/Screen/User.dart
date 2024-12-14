import 'dart:convert'; // Nhập thư viện để làm việc với JSON
import 'package:dacn/Model/user_model.dart'; // Nhập mô hình người dùng
import 'package:dacn/Provider/userProvider.dart'; // Nhập provider để quản lý trạng thái người dùng
import 'package:dacn/Screen/EditProfile.dart'; // Nhập màn hình chỉnh sửa thông tin người dùng
import 'package:dacn/Widget/User.dart'; // Nhập widget cho người dùng
import 'package:flutter/material.dart'; // Nhập thư viện Flutter
import 'package:provider/provider.dart'; // Nhập thư viện Provider để quản lý trạng thái
import 'package:http/http.dart' as http; // Nhập thư viện HTTP

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key}); // Constructor cho màn hình thông tin người dùng

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(); // Tạo trạng thái cho màn hình
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user; // Biến lưu thông tin người dùng
  bool _isLoading = true; // Biến quản lý trạng thái loading

  @override
  void initState() {
    super.initState();
    _getUserData(); // Gọi hàm để tải thông tin người dùng khi khởi tạo
  }

  // Hàm lấy thông tin người dùng từ server
  Future<void> _getUserData() async {
    const String url = 'http://192.168.1.7:8080/api/users/me'; // Địa chỉ API để lấy thông tin người dùng

    try {
      final userToken = Provider.of<UserProvider>(context, listen: false).token; // Lấy token người dùng từ Provider

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Thiết lập header là JSON
          'Authorization': 'Bearer $userToken', // Thêm token vào header
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body); // Giải mã phản hồi JSON
        setState(() {
          user = User.fromJson(jsonData); // Chuyển đổi JSON thành mô hình User
          _isLoading = false; // Kết thúc trạng thái loading
        });
      } else {
        _showErrorSnackbar('Không thể tải dữ liệu: ${response.reasonPhrase}'); // Hiển thị thông báo lỗi
        setState(() {
          _isLoading = false; // Kết thúc trạng thái loading nếu có lỗi
        });
      }
    } catch (error) {
      print('Error fetching user data: $error'); // In lỗi ra console để kiểm tra
      _showErrorSnackbar('Lỗi khi tải dữ liệu người dùng: $error'); // Hiển thị thông báo lỗi
      setState(() {
        _isLoading = false; // Kết thúc trạng thái loading nếu có lỗi
      });
    }
  }
  
  // Hàm hiển thị thông báo lỗi
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)), // Hiển thị SnackBar với thông báo
    );
  }
  
  // Hàm điều hướng đến màn hình chỉnh sửa thông tin
  Future<void> _navigateToEditProfile() async {
    if (user != null) {
      final updatedUser = await Navigator.push<User>(
          context,
          MaterialPageRoute(
              builder: (context) => EditProfileScreen(user: user!,)), // Chuyển đến màn hình chỉnh sửa
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
    if (_isLoading) { // Nếu đang loading, trả về một Spinner
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) { // Nếu không có thông tin người dùng, hiển thị thông báo
      return const Center(child: Text('Không có thông tin người dùng'));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF6A11CB), // Màu nền AppBar
        title: const Text(
          "Thông Tin Người Dùng", // Tiêu đề AppBar
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Căn giữa tiêu đề
      ),
      body: RefreshIndicator(
        onRefresh: _getUserData, // Gọi lại hàm tải dữ liệu khi kéo để làm mới
        child: SingleChildScrollView( // Cho phép cuộn khi nội dung dài
          child: Column(
            children: [
              // Header profile
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], // Màu gradient cho nền header
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Container(
                  width: double.infinity, // Chiều rộng 100%
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      // Hình đại diện người dùng
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white, // Màu nền cho avatar
                        child: CircleAvatar(
                          radius: 46,
                          backgroundImage: user?.image != null 
                            ? NetworkImage(user!.image) // Hình ảnh từ URL
                            : const AssetImage('assets/Images/User.jpg'), // Hình ảnh mặc định
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user!.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Màu chữ
                        ),
                      ),
                      Text(
                        user!.email, // Hiển thị email
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
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho nội dung
                  children: [
                    const Text(
                      "Thông Tin Tài Khoản", // Tiêu đề phần thông tin tài khoản
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A11CB),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Thể hiện thông tin người dùng
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 10), // Khoảng cách giữa các thẻ
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Color(0xFF6A11CB)), // Biểu tượng người dùng
                        title: const Text("Họ Tên"),
                        subtitle: Text(user!.name), // Hiển thị họ tên
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: const Icon(Icons.email, color: Color(0xFF6A11CB)), // Biểu tượng email
                        title: const Text("Email"),
                        subtitle: Text(user!.email), // Hiển thị email
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: const Icon(Icons.phone, color: Color(0xFF6A11CB)), // Biểu tượng điện thoại
                        title: const Text("Số Điện Thoại"),
                        subtitle: Text(user!.phone), // Hiển thị số điện thoại
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: const Icon(Icons.home, color: Color(0xFF6A11CB)), // Biểu tượng địa chỉ
                        title: const Text("Địa Chỉ"),
                        subtitle: Text(user!.address), // Hiển thị địa chỉ
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Phần thao tác
                    const Text(
                      "Thao Tác",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A11CB),
                      ),
                    ),
                    const SizedBox(height: 10),
                    UserWidget.actionButton( // Nút chỉnh sửa thông tin
                      icon: Icons.edit,
                      label: "Chỉnh Sửa Thông Tin",
                      onTap: _navigateToEditProfile,  // Gọi hàm điều hướng đến chỉnh sửa
                    ),
                    UserWidget.actionButton( // Nút đăng xuất
                      icon: Icons.logout,
                      label: "Đăng Xuất",
                      onTap: () {
                        Navigator.pushNamed(context, '/login'); // Chuyển đến màn hình đăng nhập
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
