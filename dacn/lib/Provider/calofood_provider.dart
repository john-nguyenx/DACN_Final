import 'package:flutter/material.dart';

class CalorieProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _foodList = [];
  int _totalCalories = 0;

  List<Map<String, dynamic>> get foodList => _foodList;

  int get totalCalories => _totalCalories;

  void addFood(String name, double quantity, int calories) {
    _foodList.add({
      'name': name,
      'quantity': quantity,
      'calories': calories,
    });
    _totalCalories += calories;
    notifyListeners();
  }

  void clear() {
    _foodList.clear();
    _totalCalories = 0;
    notifyListeners();
  }
}
