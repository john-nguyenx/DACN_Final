import 'package:flutter/material.dart';

/// Enum để định nghĩa tên bữa ăn
enum MealName { morning, lunch, afternoon, evening }

/// Class Meal để quản lý thông tin bữa ăn
class Meal {
  String name;
  double calories;  // Lượng calo cho bữa ăn
  String time;      // Thời gian đã chọn
  Meal({required this.name, required this.calories, this.time = 'Chưa chọn'});
}

/// Hàm hiển thị Snackbar
void showSnackbar(BuildContext context, String title, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$title\n$message'),
      duration: const Duration(seconds: 5),
    ),
  );
}