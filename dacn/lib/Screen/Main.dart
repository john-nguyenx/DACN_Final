import 'package:dacn/Screen/ChatAi.dart';
import 'package:dacn/Screen/Diet.dart';
import 'package:dacn/Screen/Heart.dart';
import 'package:dacn/Screen/Home.dart';
import 'package:dacn/Screen/Steps.dart';
import 'package:dacn/Screen/User.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;

  static const List<Widget> _screen = <Widget>[
    HomeScreen(),
    StepsScreen(),
    DietScreen(),
    HeartRateScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Kiểu cố định
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Heart'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Diet'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: 'Steps'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'), 
        ],
        currentIndex: _selectedIndex, // Chỉ số được chọn
        selectedItemColor: Colors.green, // Màu mục chọn
        onTap: _onItemTapped, // Gọi _onItemTapped khi người dùng nhấn
      ),
      floatingActionButton: FloatingActionButton(
         onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
          },
          child: const Icon(Icons.message),  
      )
    );
  }
}