import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dacn/Screen/Meal.dart';

class DietItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final DateTime selectedDate;

  const DietItem({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.selectedDate,
  }) : super(key: key);

  Future<double> loadTotalCalories(String mealKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateKey = selectedDate.toIso8601String().split("T")[0]; 
    return prefs.getDouble('${mealKey}_calories_$dateKey') ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MealSetupScreen(
              mealKey: title,
              selectedDate: selectedDate,
            ),
          ),
        );
      },
      child: FutureBuilder<double>(
        future: loadTotalCalories(title), // lấy tổng calo
        builder: (context, snapshot) {
          String timeText = 'Thời gian: Chưa chọn'; // Thay đổi theo yêu cầu của bạn
          String calorieText = 'Calo: ${snapshot.connectionState == ConnectionState.waiting ? 'Đang load...' : snapshot.data?.toStringAsFixed(0) ?? '0'}';

          return Container(
            width: 150,
            height: 150,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8.0,
                  spreadRadius: 2.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 50.0, color: Colors.blue),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  timeText, // Hiển thị thời gian
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  calorieText, // Hiển thị tổng calo
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
