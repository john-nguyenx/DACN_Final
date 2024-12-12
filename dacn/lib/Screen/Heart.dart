import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({Key? key}) : super(key: key);

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
        title: Text('Đo nhịp tim', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                      if (data.length >= 100) data.removeAt(0);
                      data.add(value);
                    });
                  },
                  onBPM: (value) => setState(() {
                    if (bpmValues.length >= 100) bpmValues.removeAt(0);
                    bpmValues.add(SensorValue(
                        value: value.toDouble(), time: DateTime.now()));
                  }),
                ),
              SizedBox(height: 20),
              if (isBPMEnabled && data.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
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
                    child: BPMChart(data),
                  ),
                ),
              SizedBox(height: 20),
              if (isBPMEnabled && bpmValues.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
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
                    child: BPMChart(bpmValues),
                  ),
                ),
              SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.favorite_rounded, color: Colors.white),
                    label: Text(isBPMEnabled ? "Dừng đo" : "Đo nhịp tim"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 243, 82, 255),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => setState(() {
                      isBPMEnabled = !isBPMEnabled;
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
