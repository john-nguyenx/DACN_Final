import 'package:dacn/Screen/Forget.dart';
import 'package:dacn/Screen/Main.dart';
import 'package:dacn/Screen/SignIn.dart';
import 'package:dacn/Screen/SignUp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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

