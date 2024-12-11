import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DietWidget {
  static get meals => null;

  // Vẽ biểu đồ PieChart (FL Chart)
  static Widget buildNutritionChart() {
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
}