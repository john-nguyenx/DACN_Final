import 'package:dacn/Screen/ChatAi.dart'; // Nhập màn hình chat AI
import 'package:dacn/Screen/Diet.dart'; // Nhập màn hình dinh dưỡng
import 'package:dacn/Screen/Heart.dart'; // Nhập màn hình nhịp tim
import 'package:dacn/Screen/Home.dart'; // Nhập màn hình chính
import 'package:dacn/Screen/Steps.dart'; // Nhập màn hình bước đi
import 'package:dacn/Screen/User.dart'; // Nhập màn hình người dùng
import 'package:flutter/material.dart'; // Nhập thư viện Flutter

class MainScreen extends StatefulWidget {
  const MainScreen({super.key}); // Constructor với khóa duy nhất

  @override
  State<MainScreen> createState() => _MainScreenState(); // Trạng thái cho màn hình chính
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Chỉ số màn hình hiện tại được chọn

  // Danh sách các màn hình tương ứng với chỉ số
  static final List<Widget> _screen = <Widget>[
    const HomeScreen(), // Màn hình chính
    const StepsScreen(), // Màn hình bước đi
    const DietScreen(), // Màn hình dinh dưỡng
    const HeartRateScreen(), // Màn hình nhịp tim
    const ProfileScreen(), // Màn hình người dùng
  ];

  // Hàm xử lý khi người dùng chọn một mục trong thanh điều hướng
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số màn hình được chọn
    });
  }

  @override
  void initState() {
    super.initState(); // Gọi phương thức khởi tạo của lớp cha
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedIndex], // Hiển thị màn hình tương ứng với chỉ số
      backgroundColor: Colors.black, // Màu nền của màn hình chính
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Kiểu thanh điều hướng cố định
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'), // Mục Home
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: 'Steps'), // Mục Steps
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Diet'), // Mục Diet
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Heart'), // Mục Heart
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'), // Mục User
        ],
        currentIndex: _selectedIndex, // Chỉ số hiện tại trên thanh điều hướng
        selectedItemColor: Colors.green, // Màu của mục đã chọn
        onTap: _onItemTapped, // Gọi hàm xử lý khi nhấn mục
      ),
      floatingActionButton: FloatingActionButton(
         onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen())); // Chuyển đến màn hình chat
         },
          child: const Icon(Icons.message), // Biểu tượng cho nút chat
      ),
    );
  }
}
