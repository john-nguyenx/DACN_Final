import 'dart:async'; 
import 'package:dacn/Provider/steps_provider.dart'; 
import 'package:dacn/Utils/steps_utils.dart'; 
import 'package:flutter/material.dart'; 
import 'package:pedometer/pedometer.dart'; 
import 'package:provider/provider.dart'; 
import 'package:sensors_plus/sensors_plus.dart'; 
import 'package:fl_chart/fl_chart.dart'; 
import 'package:intl/intl.dart'; 

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  State<StepsScreen> createState() => _StepsScreenState(); 
}

class _StepsScreenState extends State<StepsScreen> {
  late Stream<StepCount> _stepCountStream; 
  final StepsDetailsUtils stepsUtils = StepsDetailsUtils(); 
  int _stepCount = 0; 
  String _status = '?'; 

  @override
  void initState() {
    super.initState();
    _initializeStepsUtils();
    _startAccelerometerListening(); 
  }

  Future<void> _initializeStepsUtils() async {
    try {
      await stepsUtils.loadSteps(); 
      await stepsUtils.initPlatformState(); 
      stepsUtils.stepCountSubscription = stepsUtils.stepCountStream.listen((event) {
        _handleStepCount(event);
      });
    } catch (e) {
      print("Error initializing StepsDetailsUtils: $e"); 
    }
  }

  void _handleStepCount(StepCount event) {
    stepsUtils.onStepCount(event, Provider.of<StepsProvider>(context, listen: false));
    setState(() {
      _stepCount = stepsUtils.stepCount; // Update current step count
      // Notify `StepsProvider` so that it can update its labels or charts
    });
  }

  void _startAccelerometerListening() {
    stepsUtils.accelerometerSubscription = accelerometerEvents.listen(stepsUtils.detectShake);
  }

  @override
  void dispose() {
    stepsUtils.stepCountSubscription?.cancel();
    stepsUtils.pedestrianStatusSubscription?.cancel();
    stepsUtils.accelerometerSubscription?.cancel();
    super.dispose();
  }

  // Building the chart widget
  Widget _buildStepsChart() {
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
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
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(7, (index) {
                return FlSpot(index.toDouble(), stepsUtils.weeklySteps[index]); // Use weekly steps data
              }),
              isCurved: true,
              color: Colors.red,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: List.generate(7, (index) {
                return FlSpot(index.toDouble(), stepsUtils.weeklyKcal[index]); // Use weekly steps data
              }),
              isCurved: true,
              color: Colors.amber,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chi tiết bước đi'), 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                DateFormat('EE-dd-MMMM-y').format(DateTime.now()), 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            _buildStepsChart(), // Show the step chart
            const SizedBox(height: 30),
            _buildStepsCard(), // Show current steps and calories
          ],
        ),
      ),
    );
  }

  // Building the card to display current step and calorie count
  Widget _buildStepsCard() {
    return Card(
      color: const Color.fromARGB(255, 39, 61, 188),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Số bước", style: TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _status == 'walking'
                      ? Icons.directions_walk 
                      : _status == 'stopped'
                          ? Icons.accessibility_new 
                          : Icons.error, 
                  size: 50,
                  color: _status == 'walking' ? Colors.green : Colors.white,
                ),
                const SizedBox(width: 16),
                Text(
                  _stepCount.toString(), 
                  style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 43, 230, 124)),
                ),
                const SizedBox(width: 16),
                Text(
                  "kcal: ${(stepsUtils.weeklyKcal[DateTime.now().weekday - 1]).toInt()}",
                  style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
