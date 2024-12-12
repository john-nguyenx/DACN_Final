import 'package:dacn/Screen/Food.dart';
import 'package:dacn/Utils/diet_utils.dart';
import 'package:flutter/material.dart';

class MealDetailScreen extends StatefulWidget {
  final Meal meal;
  final Function(String) onTimeChanged;

  const MealDetailScreen({
    Key? key,
    required this.meal,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  List<Map<String, dynamic>> selectedFoods = [];

  void _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      String formattedTime = selectedTime.format(context);
      setState(() {
        widget.meal.time = formattedTime;
      });
      widget.onTimeChanged(formattedTime);
    }
  }

  void _addFood(BuildContext context) async {
  final selectedFood = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CalorieScreen()),
  );

  if (selectedFood != null && selectedFood is Map<String, dynamic>) {
    // Kiểm tra xem thực phẩm đã có trong danh sách chưa
    bool exists = selectedFoods.any((food) => food['name'] == selectedFood['name']); // Sử dụng id hoặc tên duy nhất

    if (!exists) {
      setState(() {
        selectedFoods.add(selectedFood); // Thêm thực phẩm vào danh sách
      });
    } else {
      // Thông báo nếu thực phẩm đã tồn tại
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thực phẩm đã tồn tại trong danh sách.')),
      );
    }
  } else {
    // Thông báo nếu không chọn thực phẩm
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không có thực phẩm nào được chọn.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết bữa ăn: ${widget.meal.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lượng calo: ${widget.meal.calories} calo',
                    style: const TextStyle(fontSize: 18, color: Colors.black)),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Text(
                    'Thời gian: ${widget.meal.time}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Thực phẩm bao gồm:', style: TextStyle(fontSize: 25)),
            Expanded(
              child: ListView.builder(
                itemCount: selectedFoods.length,
                itemBuilder: (context, index) {
                  final food = selectedFoods[index];
                  return ListTile(
                    title: Text(food['name'], style: const TextStyle(fontSize: 18)), // Fixed fontSize
                    subtitle: Text('Cal: ${food['calories']} calo/100g', style: const TextStyle(fontSize: 16)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addFood(context),
        child: const Icon(Icons.add),
        tooltip: 'Thêm thực phẩm', // Added tooltip for accessibility
      ),
    );
  }
}
