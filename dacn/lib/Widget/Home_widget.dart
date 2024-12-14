import 'package:dacn/Provider/calofood_provider.dart';
import 'package:dacn/Provider/steps_provider.dart';
import 'package:dacn/Screen/Exercise.dart';
import 'package:flutter/material.dart';

class HomeWidget{
  static Widget buildButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue[100]),
        overlayColor: MaterialStateProperty.all(const Color.fromARGB(255, 255, 255, 255)),
      ),
        onPressed: () => Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => WorkoutScreen(),
          )
        ),
       child: ListTile(
        title: const Text('Tập luyện', style: TextStyle(fontSize: 20)),
        subtitle: const Text('Hãy tập luyện mỗi ngày để cơ thể khỏe mạnh hơn' , style: TextStyle(fontSize: 14),),
        trailing: Icon(Icons.fitness_center, color: Colors.blue[900], size: 40),
        iconColor: Colors.blue,
       ),
       );
  }
}
