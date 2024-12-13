import 'dart:convert';
import 'package:dacn/Screen/Food.dart';
import 'package:dacn/Utils/diet_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealSetupScreen extends StatefulWidget {
  final String mealKey;
  final DateTime selectedDate;

  const MealSetupScreen({super.key, required this.mealKey, required this.selectedDate});

  @override
  _MealSetupScreenState createState() => _MealSetupScreenState();
}

class _MealSetupScreenState extends State<MealSetupScreen> {
  final TextEditingController _mealController = TextEditingController();
  final List<Map<String, dynamic>> _selectedFoods = [];
  String _selectedTime = 'Chưa chọn';

  @override
  void initState() {
    super.initState();
    _loadMealData();
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      String formattedTime = DietUtils.formatTime(pickedTime); // Sử dụng utils để định dạng thời gian
      await DietUtils.saveData('${widget.mealKey}_time_${widget.selectedDate.toIso8601String().split("T")[0]}', formattedTime); // Lưu thời gian

      setState(() {
        _selectedTime = formattedTime;
      });
      DietUtils.showSnackbar(context, 'Thời gian đã lưu', 'Đã lưu thời gian: $formattedTime cho ${widget.mealKey}');
    }
  }

  Future<void> _saveMealData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateKey = widget.selectedDate.toIso8601String().split("T")[0];
    
    // Lưu thông tin bữa ăn
    await prefs.setString('${widget.mealKey}_$dateKey', _mealController.text);

    // Lưu danh sách thực phẩm
    List<String> foodList = _selectedFoods.map((food) => jsonEncode(food)).toList();
    await prefs.setStringList('${widget.mealKey}_foods_$dateKey', foodList);

    // Tính và lưu tổng calo
    double totalCalories = DietUtils.calculateTotalCalories(_selectedFoods);
    await prefs.setDouble('${widget.mealKey}_calories_$dateKey', totalCalories);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu thông tin bữa ăn!')));
  }


  Future<void> _loadMealData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateKey = widget.selectedDate.toIso8601String().split("T")[0];

    setState(() {
      _mealController.text = prefs.getString('${widget.mealKey}_$dateKey') ?? '';
      _selectedTime = prefs.getString('${widget.mealKey}_time_$dateKey') ?? 'Chưa chọn';
      List<String>? foodList = prefs.getStringList('${widget.mealKey}_foods_$dateKey');
      if (foodList != null) {
        _selectedFoods.clear();
        for (String food in foodList) {
          _selectedFoods.add(jsonDecode(food));
        }
      }
    });
  }

  Future<int?> _showQuantityDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nhập số lượng'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Ví dụ: 1, 2, 3..."),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              child: const Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Xác nhận'),
              onPressed: () {
                Navigator.of(context).pop(int.tryParse(controller.text));
              },
            ),
          ],
        );
      },
    );
  }

  void _selectFood(BuildContext context) async {
    final selectedFood = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalorieScreen()),
    );

    if (selectedFood != null) {
      bool foodExists = _selectedFoods.any((food) => food['name'] == selectedFood['name']);

      if (foodExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${selectedFood['name']} đã được chọn! Vui lòng chọn thực phẩm khác.')),
        );
      } else {
        int? quantity = await _showQuantityDialog(context);
        if (quantity != null) {
          selectedFood['quantity'] = quantity;
          setState(() {
            _selectedFoods.add(selectedFood);
            _mealController.text = selectedFood['name'];
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    double totalCalories = DietUtils.calculateTotalCalories(_selectedFoods);
    return Scaffold(
      appBar: AppBar(
        title: Text('Thiết lập ${widget.mealKey}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _selectFood(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 42, 219, 119), Color.fromARGB(255, 37, 230, 237), Color.fromARGB(255, 96, 232, 191)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng calo: $totalCalories',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 12, 71, 199)),
                  child: Text(_selectedTime, style: const TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Chi tiết bữa ăn:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: const Offset(0, 2)),
                ]),
                child: ListView.builder(
                  itemCount: _selectedFoods.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      child: ListTile(
                        title: Text(_selectedFoods[index]['name']),
                        subtitle: Text('Calo: ${_selectedFoods[index]['calories']}/100g'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedFoods.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child:  ElevatedButton(
                onPressed: () {
                  _saveMealData();
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 39, 255, 46)),
                child: const Text('Lưu Bữa ăn', style: TextStyle(fontSize: 18, color: Colors.blue)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
