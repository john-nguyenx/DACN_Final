import 'package:flutter/foundation.dart'; // Import to use ChangeNotifier
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences

class CalorieProvider with ChangeNotifier {
  List<double> _weeklyKcal = List.filled(7, 0.0); // Store calories for the last 7 days

  // Getter for accessing weekly calories
  List<double> get weeklyKcal => _weeklyKcal;

  // Getter for today's total calorie intake
  double get totalCaloriesToday {
    String todayKey = DateTime.now().toIso8601String().split('T')[0]; // Get today's date
    return _weeklyKcal[DateTime.now().weekday - 1]; // Return today's calories based on the day of the week
  }

  // Method to update calories for a specific day
  Future<void> updateCaloriesForDay(int dayIndex, double calories) async {
    if (dayIndex >= 0 && dayIndex < _weeklyKcal.length) {
      _weeklyKcal[dayIndex] = calories; // Update the calorie intake for the specified day
      notifyListeners(); // Notify listeners of the change
      await _saveWeeklyKcal(); // Save the updated weekly kcal to SharedPreferences
    }
  }

  // Method to load weekly calorie data from SharedPreferences
  Future<void> loadWeeklyKcal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 7; i++) {
      String dateKey = DateTime.now().subtract(Duration(days: 6 - i)).toIso8601String().split('T')[0];
      double calories = prefs.getDouble('calories_$dateKey') ?? 0.0; // Load calories or default to 0
      _weeklyKcal[i] = calories; // Store loaded calories for the week
    }
    notifyListeners(); // Notify listeners for UI update
  }

  // Method to save the weekly calorie data to SharedPreferences
  Future<void> _saveWeeklyKcal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 7; i++) {
      String dateKey = DateTime.now().subtract(Duration(days: i)).toIso8601String().split('T')[0];
      await prefs.setDouble('calories_$dateKey', _weeklyKcal[i]); // Save the calories for each day
    }
  }
}
