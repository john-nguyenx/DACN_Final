import 'dart:io';

import 'package:dacn/Provider/userProvider.dart';
import 'package:dacn/Provider/weatherProvider.dart';
import 'package:dacn/Screen/Forget.dart';
import 'package:dacn/Screen/Main.dart';
import 'package:dacn/Screen/SignIn.dart';
import 'package:dacn/Screen/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
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
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => SignInScreen(),
        '/home': (context) => MainScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
      },
    );
  }
}

