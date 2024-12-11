import 'dart:async';
import 'package:dacn/Screen/Food.dart';
import 'package:dacn/Screen/Meal.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Thư viện vẽ biểu đồ
import 'package:dacn/Utils/diet_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  List<Meal> meals = []; // Danh sách các bữa ăn

  @override
  void initState() {
    super.initState();
    _loadSavedTimes();
  }

  



  @override
  void dispose() {
    super.dispose();
  }

  // Nạp dữ liệu bữa ăn từ SharedPreferences
  Future<void> _loadSavedTimes() async {
    meals = await loadSavedMeals(); // Gọi hàm từ utils
    setState(() {});
  }

  // Hàm hiển thị TimePicker
  Future<void> _selectTime(BuildContext context, Meal meal) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context); // Ví dụ: 08:30 AM
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(meal.name, formattedTime);

      double? mealCalories = await showCalorieInputDialog(context); // Nhập calo cho bữa ăn
      if (mealCalories != null) {
        await prefs.setDouble('${meal.name}_calories', mealCalories); // Lưu calo
        setState(() {
          meal.time = formattedTime;
          meal.calories = mealCalories; // Cập nhật lượng calo
        });

        // Hiển thị thông báo xác nhận
        showSnackbar(context, 'Đã lưu thời gian:', 'Thời gian: $formattedTime và Lượng calo: ${mealCalories.toStringAsFixed(0)} calo cho ${meal.name}');
      }
    }
  }

  // Vẽ biểu đồ PieChart (FL Chart)
  Widget _buildNutritionChart() {
    final totalCalories = meals.fold(0.0, (sum, meal) => sum + meal.calories); // Tổng calo

    final dataMap = {
      for (var meal in meals) 
        meal.name: totalCalories > 0 ? (meal.calories / totalCalories) * 100 : 0.0,
    };

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: dataMap.entries.map((e) {
            return PieChartSectionData(
              color: e.key == "Buổi sáng"
                  ? Colors.blue
                  : e.key == "Buổi trưa"
                      ? Colors.green
                      : e.key == "Buổi chiều"
                          ? Colors.orange
                          : Colors.red,
              value: e.value,
              title: '${e.key}\n${e.value.toStringAsFixed(2)}%',
              radius: 60,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Dinh Dưỡng'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Biểu đồ dinh dưỡng
          Center(
            child: Column(
              children: [
                const Text(
                  'Biểu đồ dinh dưỡng',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildNutritionChart(),
              ],
            ),
          ),
          // Hiển thị các bữa ăn
          Column(
            children: meals.map((meal) {
              return _buildDietItem(meal);
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget để hiển thị từng bữa ăn
  Widget _buildDietItem(Meal meal) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          meal.name == "Buổi sáng"
              ? Icons.breakfast_dining
              : meal.name == "Buổi trưa"
                  ? Icons.lunch_dining
                  : meal.name == "Buổi chiều"
                      ? Icons.fitness_center
                      : Icons.nightlife,
          size: 40.0,
        ),
        title: Text(
          meal.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Thời gian đã chọn: ${meal.time}\nLượng calo: ${meal.calories.toStringAsFixed(0)} calo',
        ),
        onTap:() => Navigator.push(context, MaterialPageRoute(builder: (context) => CalorieScreen())),
      ),
    );
  }
}
