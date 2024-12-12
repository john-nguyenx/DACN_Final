<<<<<<< HEAD
<<<<<<< HEAD
import 'package:dacn/Provider/calofood_provider.dart';
=======
>>>>>>> parent of 42ce239 (Server)
=======
>>>>>>> parent of 42ce239 (Server)
import 'package:dacn/Screen/Forget.dart';
import 'package:dacn/Screen/Main.dart';
import 'package:dacn/Screen/SignIn.dart';
import 'package:dacn/Screen/SignUp.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalorieProvider(),
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
      initialRoute: '/home',
      routes: {
        '/login': (context) => SignInScreen(),
        '/home': (context) => MainScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
      },
    );
  }
}

