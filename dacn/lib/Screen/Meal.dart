import 'dart:convert'; // Nhập thư viện để chuyển đổi JSON
import 'package:dacn/Screen/Food.dart'; // Nhập màn hình thực phẩm
import 'package:dacn/Utils/diet_utils.dart'; // Nhập tiện ích dinh dưỡng
import 'package:flutter/material.dart'; // Nhập thư viện Flutter
import 'package:shared_preferences/shared_preferences.dart'; // Nhập thư viện để lưu trữ dữ liệu

class MealSetupScreen extends StatefulWidget {
  final String mealKey; // Khóa của bữa ăn, ví dụ: 'bữa sáng', 'bữa trưa', ...
  final DateTime selectedDate; // Ngày đã chọn cho bữa ăn

  const MealSetupScreen({super.key, required this.mealKey, required this.selectedDate});

  @override
  _MealSetupScreenState createState() => _MealSetupScreenState();
}

class _MealSetupScreenState extends State<MealSetupScreen> {
  final TextEditingController _mealController = TextEditingController(); // Controller để quản lý nhập liệu tên bữa ăn
  final List<Map<String, dynamic>> _selectedFoods = []; // Danh sách thực phẩm đã chọn
  String _selectedTime = 'Chưa chọn'; // Thời gian đã chọn cho bữa ăn

  @override
  void initState() {
    super.initState();
    _loadMealData(); // Tải dữ liệu bữa ăn đã lưu
  }

  // Hàm để chọn thời gian bữa ăn
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Thời gian mặc định là thời điểm hiện tại
    );

    if (pickedTime != null) {
      String formattedTime = DietUtils.formatTime(pickedTime); // Sử dụng utils để định dạng thời gian
      await DietUtils.saveData('${widget.mealKey}_time_${widget.selectedDate.toIso8601String().split("T")[0]}', formattedTime); // Lưu thời gian

      setState(() {
        _selectedTime = formattedTime; // Cập nhật thời gian đã chọn
      });
      DietUtils.showSnackbar(context, 'Thời gian đã lưu', 'Đã lưu thời gian: $formattedTime cho ${widget.mealKey}');
    }
  }

  // Hàm để lưu dữ liệu bữa ăn vào SharedPreferences
  Future<void> _saveMealData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Lấy instance của SharedPreferences
    String dateKey = widget.selectedDate.toIso8601String().split("T")[0]; // Chọn ngày theo định dạng ISO

    // Lưu thông tin bữa ăn
    await prefs.setString('${widget.mealKey}_$dateKey', _mealController.text); // Lưu tên bữa ăn

    // Lưu danh sách thực phẩm
    List<String> foodList = _selectedFoods.map((food) => jsonEncode(food)).toList(); // Mã hóa danh sách thực phẩm dưới dạng JSON
    await prefs.setStringList('${widget.mealKey}_foods_$dateKey', foodList); // Lưu danh sách thực phẩm

    // Tính và lưu tổng calo
    double totalCalories = DietUtils.calculateTotalCalories(_selectedFoods); // Tính tổng calo từ danh sách thực phẩm
    await prefs.setDouble('${widget.mealKey}_calories_$dateKey', totalCalories); // Lưu tổng calo

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu thông tin bữa ăn!'))); // Hiển thị thông báo đã lưu
  }

  // Hàm để tải dữ liệu bữa ăn từ SharedPreferences
  Future<void> _loadMealData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Lấy instance của SharedPreferences
    String dateKey = widget.selectedDate.toIso8601String().split("T")[0]; // Chọn ngày theo định dạng ISO

    setState(() {
      _mealController.text = prefs.getString('${widget.mealKey}_$dateKey') ?? ''; // Tải tên bữa ăn
      _selectedTime = prefs.getString('${widget.mealKey}_time_$dateKey') ?? 'Chưa chọn'; // Tải thời gian
      List<String>? foodList = prefs.getStringList('${widget.mealKey}_foods_$dateKey'); // Tải danh sách thực phẩm
      if (foodList != null) {
        _selectedFoods.clear(); // Xóa danh sách thực phẩm trước đó
        for (String food in foodList) {
          _selectedFoods.add(jsonDecode(food)); // Giải mã JSON và thêm vào danh sách
        }
      }
    });
  }

  // Hàm hiển thị hộp thoại nhập số lượng cho thực phẩm
  Future<int?> _showQuantityDialog(BuildContext context) {
    TextEditingController controller = TextEditingController(); // Controller cho hộp thoại nhập liệu
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nhập số lượng'), // Tiêu đề hộp thoại
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Ví dụ: 1, 2, 3..."), // Gợi ý nhập liệu
            keyboardType: TextInputType.number, // Kiểu nhập số
          ),
          actions: [
            TextButton(
              child: const Text('Hủy'), // Nút hủy
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Xác nhận'), // Nút xác nhận
              onPressed: () {
                Navigator.of(context).pop(int.tryParse(controller.text)); // Quay lại với giá trị số đã nhập
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm để chọn thực phẩm
  void _selectFood(BuildContext context) async {
    final selectedFood = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalorieScreen()), // Chuyển đến màn hình chọn thực phẩm
    );

    if (selectedFood != null) {
      bool foodExists = _selectedFoods.any((food) => food['name'] == selectedFood['name']); // Kiểm tra thực phẩm đã tồn tại

      if (foodExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${selectedFood['name']} đã được chọn! Vui lòng chọn thực phẩm khác.')),
        );
      } else {
        int? quantity = await _showQuantityDialog(context); // Hiển thị hộp thoại nhập số lượng
        if (quantity != null) {
          selectedFood['quantity'] = quantity; // Thêm số lượng vào thực phẩm đã chọn
          setState(() {
            _selectedFoods.add(selectedFood); // Thêm thực phẩm vào danh sách
            _mealController.text = selectedFood['name']; // Cập nhật tên bữa ăn
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalCalories = DietUtils.calculateTotalCalories(_selectedFoods); // Tính tổng calo từ danh sách thực phẩm
    return Scaffold(
      appBar: AppBar(
        title: Text('Thiết lập ${widget.mealKey}'), // Tiêu đề ứng dụng
        actions: [
          IconButton(
            icon: const Icon(Icons.search), // Nút tìm kiếm
            onPressed: () => _selectFood(context), // Chọn thực phẩm
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
                  'Tổng calo: $totalCalories', // Hiển thị tổng calo
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context), // Chọn thời gian cho bữa ăn
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 12, 71, 199)),
                  child: Text(_selectedTime, style: const TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Chi tiết bữa ăn:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), // Tiêu đề phần chi tiết bữa ăn
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, offset: const Offset(0, 2)),
                ]),
                child: ListView.builder(
                  itemCount: _selectedFoods.length, // Số lượng thực phẩm đã chọn
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      child: ListTile(
                        title: Text(_selectedFoods[index]['name']), // Tên thực phẩm
                        subtitle: Text('Calo: ${_selectedFoods[index]['calories']}/100g'), // Hiển thị lượng calo
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), // Nút xóa thực phẩm
                          onPressed: () {
                            setState(() {
                              _selectedFoods.removeAt(index); // Xóa thực phẩm khỏi danh sách
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
                  _saveMealData(); // Lưu thông tin bữa ăn
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 39, 255, 46)),
                child: const Text('Lưu Bữa ăn', style: TextStyle(fontSize: 18, color: Colors.blue)), // Nút lưu bữa ăn
              ),
            )
          ],
        ),
      ),
    );
  }
}
