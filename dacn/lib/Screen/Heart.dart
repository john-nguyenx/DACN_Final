import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
  _HeartRateScreenState createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen> {
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  bool isBPMEnabled = false;
  HeartBPMDialog? bpmDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 82, 243),
        title: const Text('Đo nhịp tim', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (isBPMEnabled)
                  bpmDialog = HeartBPMDialog(
                    context: context,
                    showTextValues: true,
                    borderRadius: 10,
                    onRawData: (value) {
                      setState(() {
                        // Ensure we keep only the latest 100 readings
                        if (data.length >= 100) data.removeAt(0);
                        data.add(value);
                      });
                    },
                    onBPM: (value) {
                      if (value >= 30 && value <= 200) { // Validate BPM values
                        setState(() {
                          // Keep the last 100 BPM readings
                          if (bpmValues.length >= 100) bpmValues.removeAt(0);
                          bpmValues.add(SensorValue(value: value.toDouble(), time: DateTime.now()));
                        });
                      } else {
                        // Optionally, show an error message or log this data point
                        print("Invalid BPM value: $value");
                      }
                    },
                  ),
                const SizedBox(height: 20),
                if (isBPMEnabled && data.isNotEmpty)
                  _buildChartContainer(data, "Raw Data Chart"),
                const SizedBox(height: 20),
                if (isBPMEnabled && bpmValues.isNotEmpty)
                  _buildChartContainer(bpmValues, "BPM Chart"),
                const SizedBox(height: 40),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the chart container
  Widget _buildChartContainer(List<SensorValue> data, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      height: 180,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: BPMChart(data),
            ),
          ],
        ),
      ),
    );
  }

  // Action button to start/stop BPM monitoring
  Widget _buildActionButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.favorite_rounded, color: Colors.white),
      label: Text(isBPMEnabled ? "Dừng đo" : "Đo nhịp tim"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 243, 82, 255),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () => setState(() {
        isBPMEnabled = !isBPMEnabled; // Toggle the BPM measurement
      }),
    );
  }
}
