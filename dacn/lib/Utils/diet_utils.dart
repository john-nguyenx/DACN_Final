import 'package:dacn/Provider/calofood_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum để định nghĩa tên bữa ăn
enum MealName { morning, lunch, afternoon, evening }

/// Class Meal để quản lý thông tin bữa ăn
class Meal {
  String name;
  double calories;  // Lượng calo cho bữa ăn
  String time;      // Thời gian đã chọn

  Meal({required this.name, required this.calories, this.time = 'Chưa chọn'});

  // Chuyển đổi Meal thành Map để lưu vào SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'time': time,
    };
  }
  
  // Tạo một bữa ăn từ bản đồ
  static Meal fromMap(Map<String, dynamic> map) {
    return Meal(
      name: map['name'],
      calories: map['calories'],
      time: map['time'],
    );
  }
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

// Chức năng tải thời gian ăn đã lưu từ SharedPreferences
Future<Map<String, String>> loadSavedTimes() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return {
    'Buổi sáng': prefs.getString('Buổi sáng') ?? 'Chưa chọn',
    'Buổi trưa': prefs.getString('Buổi trưa') ?? 'Chưa chọn',
    'Buổi chiều': prefs.getString('Buổi chiều') ?? 'Chưa chọn',
    'Buổi tối': prefs.getString('Buổi tối') ?? 'Chưa chọn',
  };
}

// Chức năng chọn thời gian cho bữa ăn
Future<void> selectTime(BuildContext context, String key, Function(String) onTimeSelected) async {
  TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedTime != null) {
    String formattedTime = pickedTime.format(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, formattedTime);

    onTimeSelected(formattedTime); 
    showSnackbar(context, 'Thời gian đã lưu', 'Đã lưu thời gian: $formattedTime cho $key');
  }
}

class DietUtils {
  // Hiển thị snackbar
  static void showSnackbar(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Lưu dữ liệu vào SharedPreferences
  static Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    
  }

  // Lấy dữ liệu từ SharedPreferences
  static Future<String?> loadData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }


  // Xóa dữ liệu từ SharedPreferences
  static Future<void> clearData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  // Chuyển đổi thời gian thành chuỗi
  static String formatTime(TimeOfDay timeOfDay) {
    return timeOfDay.hour.toString().padLeft(2, '0') + ':' + timeOfDay.minute.toString().padLeft(2, '0');
  }

  // Tính tổng calo
  static double calculateTotalCalories(List<Map<String, dynamic>> selectedFoods) {
    double totalCalories = 0;
    for (var food in selectedFoods) {
      double caloPer100g = food['calories'] ?? 0;
      int quantityInGrams = food['quantity'] ?? 0;
      double totalCaloForFood = (caloPer100g / 100) * quantityInGrams;
      totalCalories += totalCaloForFood;
    }
    
    return totalCalories;
  }
}
