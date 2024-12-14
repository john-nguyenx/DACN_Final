import 'package:flutter/material.dart';
import 'package:dacn/Screen/ExerciseDetail.dart';

class WorkoutScreen extends StatelessWidget {
  
  final List<String> exercises = [
    'Push-ups',
    'Squats',
    'Lunges',
    'Plank',
  ];
  
  // Thêm danh sách mô tả cho từng bài tập
  final List<String> exerciseDescriptions = [
    'Tuyệt vời để xây dựng sức mạnh phần thân trên',
    'Tuyệt vời cho sức mạnh phần thân dưới',
    'Tập trung vào đùi và mông của bạn',
    'Xây dựng sức mạnh cốt lõi và sự ổn định',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Exercises'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Hành động tìm kiếm
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Chuyển đến trang chi tiết bài tập
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDetailScreen(exercise: exercises[index]),
                  ),
                );
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            exercises[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8), // Khoảng cách giữa tên bài tập và mô tả
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            exerciseDescriptions[index], // Lấy mô tả tương ứng
                            style: const TextStyle(
                              color: Colors.white70, // Màu sắc nhẹ hơn cho mô tả
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
