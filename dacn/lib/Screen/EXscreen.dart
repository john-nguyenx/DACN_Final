import 'package:dacn/Screen/GymScreen.dart';
import 'package:dacn/Screen/YogaScreen.dart';
import 'package:flutter/material.dart';

class ExScreen extends StatefulWidget {
  const ExScreen({super.key});

  @override
  State<ExScreen> createState() => _ExScreenState();
}

class _ExScreenState extends State<ExScreen> {
  // Danh sách các bài tập
  final List<String> exercises = ['Tập Gym', 'Tập Yoga'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài Tập'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Điều hướng đến trang tương ứng
                if (exercises[index] == 'Tập Gym') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GymScreen()),
                  );
                } else if (exercises[index] == 'Tập Yoga') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const YogaScreen()),
                  );
                }
              },
              child: Text(exercises[index]),
            ),
          );
        },
      ),
    );
  }
}
