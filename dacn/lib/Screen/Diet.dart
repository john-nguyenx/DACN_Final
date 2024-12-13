import 'dart:async';
import 'package:dacn/Widget/diet_widget.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  Map<String, String> selectedTimes = {};
  DateTime selectedDate = DateTime.now();
  EasyDatePickerController controller = EasyDatePickerController();
  List<double> caloriesWeeklyData = List.filled(7, 0.0); // Dữ liệu calo cho tuần

  @override
  void initState() {
    super.initState();
    _loadSavedTimes();
    _loadWeeklyCaloriesData(); // Load dữ liệu calo cho tuần
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _loadWeeklyCaloriesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < 7; i++) {
      String dateKey = DateTime.now().subtract(Duration(days: i)).toIso8601String().split("T")[0];
      double breakfastCalories = prefs.getDouble('Buổi sáng_calories_$dateKey') ?? 0.0;
      double lunchCalories = prefs.getDouble('Buổi trưa_calories_$dateKey') ?? 0.0;
      double afternoonCalories = prefs.getDouble('Buổi chiều_calories_$dateKey') ?? 0.0;
      double dinnerCalories = prefs.getDouble('Buổi tối_calories_$dateKey') ?? 0.0;

      caloriesWeeklyData[i] = breakfastCalories + lunchCalories + afternoonCalories + dinnerCalories;
    }
  }

  Future<void> _loadSavedTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateKey = selectedDate.toIso8601String().split("T")[0];

    setState(() {
      selectedTimes = {
        'Buổi sáng': prefs.getString('Buổi sáng_time_$dateKey') ?? 'Chưa chọn',
        'Buổi trưa': prefs.getString('Buổi trưa_time_$dateKey') ?? 'Chưa chọn',
        'Buổi chiều': prefs.getString('Buổi chiều_time_$dateKey') ?? 'Chưa chọn',
        'Buổi tối': prefs.getString('Buổi tối_time_$dateKey') ?? 'Chưa chọn',
      };
    });
  }

  Future<void> _refreshData() async {
    // Gọi lại thật dữ liệu, nạp ngày giờ và dữ liệu calo
    _loadSavedTimes();
    await _loadWeeklyCaloriesData();
  }

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
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0: return const Text('CN');
                      case 1: return const Text('T2');
                      case 2: return const Text('T3');
                      case 3: return const Text('T4');
                      case 4: return const Text('T5');
                      case 5: return const Text('T6');
                      case 6: return const Text('T7');
                      default: return const Text('');
                    }
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            barGroups: List.generate(7, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: caloriesWeeklyData[index],
                    color: Colors.lightBlue,
                  ),
                ],
              );
            }),
            gridData: FlGridData(
            show: true, // Hiển thị lưới
            drawHorizontalLine: true, // Hiển thị đường kẻ ngang
            drawVerticalLine: false, // Hiển thị đường kẻ dọc
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
        title: const Text('Biểu Đồ Dinh Dưỡng Tuần'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now();
                      controller.jumpToCurrentDate();
                      _loadSavedTimes();
                    });
                  },
                  child: const Icon(Icons.today, size: 30),
                )
              ],
            ),
            EasyDateTimeLinePicker(
              firstDate: DateTime(2024, 1, 1),
              lastDate: DateTime(2025, 3, 18),
              focusedDate: selectedDate,
              controller: controller,
              onDateChange: (date) {
                setState(() {
                  selectedDate = date;
                  _loadSavedTimes();
                  controller.jumpToDate(selectedDate);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only( top: 15),
              child: buildChart(), // Hiện biểu đồ
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.only(top: 1),
                children: [
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
