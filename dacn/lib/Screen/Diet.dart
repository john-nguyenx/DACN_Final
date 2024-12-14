import 'dart:async'; // Nhập thư viện cho các tác vụ bất đồng bộ
import 'package:dacn/Widget/diet_widget.dart'; // Nhập widget cho chế độ ăn
import 'package:easy_date_timeline/easy_date_timeline.dart'; // Nhập thư viện cho chọn ngày
import 'package:fl_chart/fl_chart.dart'; // Nhập thư viện cho biểu đồ
import 'package:flutter/material.dart'; // Nhập thư viện Flutter
import 'package:shared_preferences/shared_preferences.dart'; // Nhập thư viện lưu trữ dữ liệu

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  Map<String, String> selectedTimes = {}; // Lưu trữ thời gian đã chọn cho các bữa ăn
  DateTime selectedDate = DateTime.now(); // Ngày đã chọn
  EasyDatePickerController controller = EasyDatePickerController(); // Controller để chọn ngày
  List<double> caloriesWeeklyData = List.filled(7, 0.0); // Dữ liệu calo cho tuần

  @override
  void initState() {
    super.initState();
    _loadSavedTimes(); // Tải thời gian đã lưu khi khởi tạo
    _loadWeeklyCaloriesData(); // Tải dữ liệu calo cho tuần
  }

  @override
  void dispose() {
    controller.dispose(); // Giải phóng controller khi không còn sử dụng
    super.dispose();
  }

  // Hàm tải dữ liệu tổng calo cho cả tuần từ SharedPreferences
  Future<void> _loadWeeklyCaloriesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Lấy instance của SharedPreferences

    // Lặp qua 7 ngày để lấy dữ liệu calo
    for (int i = 0; i < 7; i++) {
        // Tính ngày tương ứng bắt đầu từ Chủ nhật
        String dateKey = DateTime.now().subtract(Duration(days: 6 - i)).toIso8601String().split("T")[0]; 
        double breakfastCalories = prefs.getDouble('Buổi sáng_calories_$dateKey') ?? 0.0; // Tải calo bữa sáng
        double lunchCalories = prefs.getDouble('Buổi trưa_calories_$dateKey') ?? 0.0; // Tải calo bữa trưa
        double afternoonCalories = prefs.getDouble('Buổi chiều_calories_$dateKey') ?? 0.0; // Tải calo bữa chiều
        double dinnerCalories = prefs.getDouble('Buổi tối_calories_$dateKey') ?? 0.0; // Tải calo bữa tối

        // Cộng dồn calo cho cả ngày
        caloriesWeeklyData[i] = breakfastCalories + lunchCalories + afternoonCalories + dinnerCalories;
    }
  }

  // Hàm tải thời gian đã lưu từ SharedPreferences
  Future<void> _loadSavedTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateKey = selectedDate.toIso8601String().split("T")[0]; // Chọn ngày theo định dạng ISO

    // Cập nhật trạng thái cho thời gian đã chọn
    setState(() {
      selectedTimes = {
        'Buổi sáng': prefs.getString('Buổi sáng_time_$dateKey') ?? 'Chưa chọn', // Thời gian bữa sáng
        'Buổi trưa': prefs.getString('Buổi trưa_time_$dateKey') ?? 'Chưa chọn', // Thời gian bữa trưa
        'Buổi chiều': prefs.getString('Buổi chiều_time_$dateKey') ?? 'Chưa chọn', // Thời gian bữa chiều
        'Buổi tối': prefs.getString('Buổi tối_time_$dateKey') ?? 'Chưa chọn', // Thời gian bữa tối
      };
    });
  }

  // Hàm làm mới dữ liệu khi refresh
  Future<void> _refreshData() async {
    _loadSavedTimes(); // Gọi lại dữ liệu đã lưu
    await _loadWeeklyCaloriesData(); // Tái tải dữ liệu calo
  }

  // Hàm xây dựng biểu đồ
  Widget buildChart() {
    return Container(
      width: 330,
      child: AspectRatio(
        aspectRatio: 1.5,
        child: BarChart(
          BarChartData(
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,  // Hiển thị tiêu đề dưới cùng
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    // Lập chỉ mục cho từng ngày
                    switch (value.toInt()) {
                      case 0: return const Text('CN'); // Chủ nhật
                      case 1: return const Text('T2'); // Thứ hai
                      case 2: return const Text('T3'); // Thứ ba
                      case 3: return const Text('T4'); // Thứ tư
                      case 4: return const Text('T5'); // Thứ năm
                      case 5: return const Text('T6'); // Thứ sáu
                      case 6: return const Text('T7'); // Thứ bảy
                      default: return const Text('');
                    }
                  }
                ),
              ),
            ),
            borderData: FlBorderData(show: true), // Hiển thị đường biên của biểu đồ
            barGroups: List.generate(7, (index) {
              return BarChartGroupData(
                x: index,  // Chỉ số cho từng nhóm biểu đồ
                barRods: [
                  BarChartRodData(
                    toY: caloriesWeeklyData[index], // Giá trị calo cho mỗi ngày
                    color: Colors.lightBlue, // Màu sắc cho thanh biểu đồ
                  ),
                ],
              );
            }),
            gridData: FlGridData(
              show: true, // Hiển thị lưới
              drawHorizontalLine: true, // Hiển thị đường kẻ ngang
              drawVerticalLine: false, // Không hiển thị đường kẻ dọc
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.5), // Màu sắc đường kẻ
                  strokeWidth: 0.5, // Độ dày đường kẻ
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.5), // Màu sắc đường kẻ
                  strokeWidth: 0.5, // Độ dày đường kẻ
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Biểu Đồ Dinh Dưỡng Tuần'), // Tiêu đề cho app bar
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData, // Tải lại dữ liệu khi kéo xuống
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now(); // Khi nhấn nút "Hôm nay", cập nhật ngày
                      controller.jumpToCurrentDate(); // Nhảy đến ngày hiện tại trên picker
                      _loadSavedTimes(); // Tải lại thời gian đã lưu
                    });
                  },
                  child: const Icon(Icons.today, size: 30), // Nút để chọn hôm nay
                )
              ],
            ),
            // Picker chọn ngày
            EasyDateTimeLinePicker(
              firstDate: DateTime(2024, 1, 1), // Ngày đầu tiên có thể chọn
              lastDate: DateTime(2025, 3, 18), // Ngày cuối cùng có thể chọn
              focusedDate: selectedDate, // Ngày hiện tại được chú ý
              controller: controller,
              onDateChange: (date) {
                setState(() {
                  selectedDate = date; // Cập nhật ngày đã chọn
                  _loadSavedTimes(); // Tải lại thời gian đã lưu cho ngày mới
                  controller.jumpToDate(selectedDate); // Nhảy đến ngày mới
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: buildChart(), // Hiện biểu đồ
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Số cột trong GridView
                padding: const EdgeInsets.only(top: 1),
                children: [
                  // Các mục lựa chọn thực phẩm hàng ngày
                  DietItem(
                    title: 'Buổi sáng',
                    description: 'Khởi đầu ngày mới với năng lượng lành mạnh.',
                    icon: Icons.breakfast_dining,
                    selectedDate: selectedDate,
                  ),
                  DietItem(
                    title: 'Buổi trưa',
                    description: 'Bữa ăn chính giàu dưỡng chất.',
                    icon: Icons.lunch_dining,
                    selectedDate: selectedDate,
                  ),
                  DietItem(
                    title: 'Buổi chiều',
                    description: 'Giúp cơ thể hồi phục với thực phẩm giàu protein.',
                    icon: Icons.fitness_center,
                    selectedDate: selectedDate,
                  ),
                  DietItem(
                    title: 'Buổi tối',
                    description: 'Bổ sung dinh dưỡng nhẹ nhàng, dễ tiêu.',
                    icon: Icons.nightlife,
                    selectedDate: selectedDate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
