import 'package:dacn/Screen/Meal.dart'; // Nhập màn hình bữa ăn
import 'package:flutter/material.dart'; // Nhập thư viện Flutter
import 'package:dacn/Model/food_model.dart'; // Nhập mô hình thực phẩm
import 'dart:convert'; // Nhập thư viện để chuyển đổi dữ liệu JSON
import 'package:http/http.dart' as http; // Nhập thư viện HTTP

class CalorieScreen extends StatefulWidget {
  const CalorieScreen({super.key});

  @override
  _CalorieScreenState createState() => _CalorieScreenState(); // Tạo trạng thái cho màn hình Calorie
}

class _CalorieScreenState extends State<CalorieScreen> {
  List<Map<String, String>> allFoods = []; // Danh sách tất cả thực phẩm
  List<Map<String, String>> filteredFoods = []; // Danh sách thực phẩm đã lọc theo tìm kiếm
  List<Foods> foods = []; // Danh sách thực phẩm với mô hình Foods

  // Bản đồ ánh xạ loại thực phẩm
  final Map<int, String> typeMapping = {
    1: 'Rau củ quả',
    2: 'Ngũ cốc',
    3: 'Trái cây',
    4: 'Các loại sữa',
    5: 'Các loại thịt',
    6: 'Các loại thủy hải sản',
    7: 'Món ăn khác',
  };

  final Map<String, List<Map<String, String>>> categorizedFoods = {}; // Bản đồ để phân loại thực phẩm

  @override
  void initState() {
    super.initState();
    _getFoods(); // Gọi hàm tải dữ liệu thực phẩm khi khởi tạo
  }

  // Hàm lấy dữ liệu thực phẩm từ server
  Future<void> _getFoods() async {
    const String url = 'http://192.168.1.7:8080/api/get_diet'; // Địa chỉ API để lấy dữ liệu thực phẩm
    final response = await http.get(Uri.parse(url)); // Gửi yêu cầu GET

    if (response.statusCode == 200) {
      setState(() {
        final jsonData = jsonDecode(response.body) as List; // Chuyển đổi JSON thành danh sách
        foods = jsonData.map((json) => Foods.fromJson(json)).toList(); // Map dữ liệu vào mô hình Foods

        categorizedFoods.clear(); // Xóa bản đồ phân loại trước khi thêm mới
        for (var food in foods) {
          final typeName = typeMapping[food.type] ?? 'Khác'; // Lấy tên loại thực phẩm
          categorizedFoods.putIfAbsent(typeName, () => []).add({
            'name': food.name,
            'calories': food.calories.toString(), // Chuyển đổi calo thành chuỗi
            'protein': food.protein.toString(),
            'fat': food.fat.toString(),
            'fiber': food.fiber.toString(),
          });
        }

        allFoods.clear();
        categorizedFoods.forEach((_, foods) => allFoods.addAll(foods)); // Thêm tất cả thực phẩm vào danh sách allFoods
        filteredFoods = List.from(allFoods); // Sao chép danh sách thực phẩm đã lọc
      });
    } else {
      print('Failed to load foods: ${response.statusCode}'); // Xuất lỗi nếu không tải được thực phẩm
    }
  }

  // Hàm lọc kết quả tìm kiếm
  void filterResults(String query) {
    setState(() {
      filteredFoods = query.isEmpty
          ? List.from(allFoods) // Nếu truy vấn rỗng, hiển thị tất cả thực phẩm
          : allFoods
              .where((food) => food['name']?.toLowerCase().contains(query.toLowerCase()) ?? false)
              .toList(); // Lọc các thực phẩm theo tên
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng thông tin Calo'), // Tiêu đề của app bar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70), // Kích thước của phần dưới app bar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty(); // Trả về rỗng nếu không có truy vấn
                }
                return allFoods
                    .map((food) => food['name']!)
                    .where((name) => name.toLowerCase().contains(textEditingValue.text.toLowerCase())); // Lọc theo tên thực phẩm
              },
              onSelected: (String selection) {
                setState(() {
                  filteredFoods = allFoods
                      .where((food) => food['name']!.toLowerCase() == selection.toLowerCase()) // Lọc thực phẩm theo mục đã chọn
                      .toList();
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm thực phẩm...', // Gợi ý cho trường tìm kiếm
                    prefixIcon: const Icon(Icons.search), // Biểu tượng tìm kiếm
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0), // Bo tròn góc cho border
                    ),
                  ),
                  onChanged: (value) => filterResults(value), // Gọi hàm lọc khi thay đổi
                );
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredFoods.length, // Số lượng thực phẩm đã lọc
        itemBuilder: (context, index) {
          final food = filteredFoods[index]; // Lấy thực phẩm đã lọc
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15), // Khoảng cách cho card
            child: GestureDetector(
              onTap: () {
                // Khi người dùng nhấn vào món ăn, quay lại và trả về dữ liệu món ăn đã chọn
                Navigator.pop(
                  context,
                  {
                    'name': food['name']!,
                    'calories': double.tryParse(food['calories'] ?? '0') ?? 0, // Đảm bảo an toàn khi phân tích
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Padding cho card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho nội dung
                  children: [
                    Text(food['name']!, style: const TextStyle(fontWeight: FontWeight.bold)), // Hiển thị tên món ăn
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn giữa cho hàng
                      children: [
                        Text('Cal: ${food['calories'] ?? 'N/A'}/100g'), // Hiển thị calo
                        Text('Protein: ${food['protein']}g'), // Hiển thị protein
                        Text('Fat: ${food['fat']}g'), // Hiển thị chất béo
                        Text('Fiber: ${food['fiber']}g'), // Hiển thị chất xơ
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
