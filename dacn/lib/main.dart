<<<<<<< Updated upstream
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:dacn/Provider/calofood_provider.dart';
=======
>>>>>>> parent of 42ce239 (Server)
=======
>>>>>>> parent of 42ce239 (Server)
=======
import 'dart:io';

import 'package:dacn/Provider/userProvider.dart';
import 'package:dacn/Provider/weatherProvider.dart';
>>>>>>> Stashed changes
import 'package:dacn/Screen/Forget.dart';
import 'package:dacn/Screen/Main.dart';
import 'package:dacn/Screen/SignIn.dart';
import 'package:dacn/Screen/SignUp.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
<<<<<<< HEAD
<<<<<<< HEAD
=======
import 'package:flutter_gemini/flutter_gemini.dart';
>>>>>>> Stashed changes
import 'package:provider/provider.dart';

void main() async {

  Gemini.init(apiKey: 'AIzaSyDvh0xxPUrEu3rwChoKm4C0G7dGKpy7FN4'); // Đảm bảo bạn có API_KEY chính xác

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), // Thêm UserProvider
        // ChangeNotifierProvider(create: (context) => BodyProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        // ChangeNotifierProvider(create: (context) => StepsProvider()),
      ],
      child: MyApp(),
    ),
  );
=======

void main() {
  runApp(MyApp());
>>>>>>> parent of 42ce239 (Server)
=======

void main() {
  runApp(MyApp());
>>>>>>> parent of 42ce239 (Server)
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const SignInScreen(),
        '/home': (context) => const MainScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
      },
    );
  }
}

