import 'package:dacn/Provider/calofood_provider.dart';
import 'package:dacn/Provider/steps_provider.dart';
import 'package:dacn/Provider/userProvider.dart';
import 'package:dacn/Provider/weatherProvider.dart';
import 'package:dacn/Widget/Home_widget.dart';
import 'package:dacn/Widget/weather_Widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<double> caloriesWeeklyData = List.filled(7, 0.0); 
  int stepCount = 0;
  String status = '?';
  bool isShaking = false;

  List<double> weeklySteps = List.generate(7, (index) => 0.0);
  List<double> weeklyKcal = List.generate(7, (index) => 0.0);

  @override
  void initState() {
    super.initState();
    loadSteps();
    _loadWeeklyCaloriesData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeatherData();
    });
  }

  Future<void> loadSteps() async {
    final prefs = await SharedPreferences.getInstance();

    weeklySteps = (prefs.getStringList('weeklySteps') ?? List.filled(7, '0')).map((e) => double.parse(e)).toList();
    weeklyKcal = (prefs.getStringList('weeklyKcal') ?? List.filled(7, '0')).map((e) => double.parse(e)).toList();

    String lastSavedDate = prefs.getString('lastSavedDate') ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastSavedDate != currentDate) {
      int dayOfWeek = DateTime.now().weekday - 1; 
      weeklySteps[dayOfWeek] = 0; // Reset steps for the new day
      weeklyKcal[dayOfWeek] = 0; 
    }
  }

  Future<void> _loadWeeklyCaloriesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); 

    for (int i = 0; i < 7; i++) {
      String dateKey = DateTime.now().subtract(Duration(days: 6 - i)).toIso8601String().split("T")[0]; 
      double breakfastCalories = prefs.getDouble('Buổi sáng_calories_$dateKey') ?? 0.0; 
      double lunchCalories = prefs.getDouble('Buổi trưa_calories_$dateKey') ?? 0.0; 
      double afternoonCalories = prefs.getDouble('Buổi chiều_calories_$dateKey') ?? 0.0; 
      double dinnerCalories = prefs.getDouble('Buổi tối_calories_$dateKey') ?? 0.0; 

      caloriesWeeklyData[i] = breakfastCalories + lunchCalories + afternoonCalories + dinnerCalories;
    }
  }

  Future<void> _fetchWeatherData() async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    await weatherProvider.fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final userImage = Provider.of<UserProvider>(context, listen: false).image;
    final calorieProvider = Provider.of<CalorieProvider>(context);
    final stepsProvider = Provider.of<StepsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/image/logo.png', width: 50),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundImage: userImage != null
                  ? NetworkImage(userImage)
                  : const AssetImage('assets/image/User.jpg'),
              radius: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () => _fetchWeatherData(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeatherCard(weatherProvider),
              const SizedBox(height: 20),
              _buildGreetingText(),
              const SizedBox(height: 10),
              _buildActivityCard(stepsProvider),
              const SizedBox(height: 20),
              HomeWidget.buildButton(context),
              const SizedBox(height: 20),
              _buildChart(calorieProvider, stepsProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard(WeatherProvider weatherProvider) {
    return Card(
      elevation: 4,
      child: SizedBox(
        height: 110,
        child: Center(
          child: weatherProvider.isLoading
              ? const CircularProgressIndicator(color: Color.fromARGB(255, 255, 0, 0))
              : weatherProvider.error != null
                  ? Text(weatherProvider.error!, style: const TextStyle(color: Colors.red))
                  : weatherProvider.weatherData != null
                      ? WeatherDetail(weather: weatherProvider.weatherData!)
                      : const Text("Data Loading...", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        ),
      ),
    );
  }

  Widget _buildGreetingText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Xin chào,', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('Hy vọng bạn có một ngày tốt lành!', style: TextStyle(fontSize: 18, color: Colors.black54)),
      ],
    );
  }

  Widget _buildActivityCard(StepsProvider stepsProvider) {
    return  Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        title: const Text('Số bước chân hiện tại:', 
        style: TextStyle(fontSize: 18, color: Colors.black)),
        subtitle: Text('Current Steps: ${stepsProvider.stepData.currentSteps}', 
        style: const TextStyle(fontSize: 16, color: Colors.black)),
        trailing: const Icon(Icons.directions_run, color: Colors.green, size: 50,),
      ),
    );
  }

  Widget _buildChart(CalorieProvider calorieProvider, StepsProvider stepsProvider) {
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) {
                  List<String> days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
                  return Text(days[value.toInt()]);
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true,
              reservedSize: 40,
            ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(7, (index) {
                return FlSpot(index.toDouble(), caloriesWeeklyData[index]); // Use weekly calories
              }),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: List.generate(7, (index) {
                return FlSpot(index.toDouble(), weeklyKcal[index]); // Use weekly steps data
              }),
              isCurved: true,
              color: Colors.red,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

}
