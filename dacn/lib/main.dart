
import 'package:dacn/Provider/calofood_provider.dart';
import 'package:dacn/Provider/steps_provider.dart';
import 'package:dacn/Provider/userProvider.dart';
import 'package:dacn/Provider/weatherProvider.dart';
import 'package:dacn/Screen/Forget.dart';
import 'package:dacn/Screen/Main.dart';
import 'package:dacn/Screen/SignIn.dart';
import 'package:dacn/Screen/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

void main() async {

  Gemini.init(apiKey: 'AIzaSyDvh0xxPUrEu3rwChoKm4C0G7dGKpy7FN4'); // Đảm bảo bạn có API_KEY chính xác

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalorieProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()), // Thêm UserProvider
        // ChangeNotifierProvider(create: (context) => BodyProvider()),
        ChangeNotifierProvider(create: (context) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => StepsProvider()),
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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        EasyDateTimelineLocalizations.delegate,
      ],
    );
  }
}
