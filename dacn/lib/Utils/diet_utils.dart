import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Class Meal để quản lý thông tin bữa ăn
class Meal {
  String name;
  double calories;  // Lượng calo cho bữa ăn
  String time;      // Thời gian đã chọn

  Meal({required this.name, required this.calories, this.time = 'Chưa chọn'});
}

/// Hàm nạp thời gian và lượng calo đã lưu từ SharedPreferences
Future<List<Meal>> loadSavedMeals() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> mealNames = ['Buổi sáng', 'Buổi trưa', 'Buổi chiều', 'Buổi tối'];
  List<Meal> meals = [];

  for (String mealName in mealNames) {
    String savedTime = prefs.getString(mealName) ?? 'Chưa chọn';
    double savedCalories = prefs.getDouble('${mealName}_calories') ?? 0;
    meals.add(Meal(name: mealName, calories: savedCalories, time: savedTime));
  }
  
  return meals;
}

/// Hàm hiển thị hộp thoại nhập lượng calo
Future<double?> showCalorieInputDialog(BuildContext context) async {
  final TextEditingController calorieController = TextEditingController();
  
  return showDialog<double>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Nhập lượng calo'),
        content: TextField(
          controller: calorieController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "Nhập lượng calo"),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              double? calories = double.tryParse(calorieController.text);
              Navigator.of(context).pop(calories);
            },
            child: const Text('Lưu'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Hủy'),
          ),
        ],
      );
    },
  );
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
