import 'package:dacn/Provider/userProvider.dart';
import 'package:dacn/Provider/weatherProvider.dart';
import 'package:dacn/Widget/weather_Widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeatherData();
    });
  }

  Future<void> _fetchWeatherData() async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    await weatherProvider.fetchWeather(); // Fetch weather data from provider
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final image = Provider.of<UserProvider>(context, listen: false).image;
    
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/image/logo.png', width: 50),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundImage:  image != null ? NetworkImage(image)  
              : const AssetImage('assets/image/User.jpg'),
              radius: 30,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchWeatherData(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                child: Card(
                  child: Center(
                    child: weatherProvider.isLoading
                        ? const CircularProgressIndicator(color: Color.fromARGB(255, 255, 0, 0))
                        : weatherProvider.error != null
                            ? Text(
                                weatherProvider.error!,
                                style: const TextStyle(color: Colors.red),
                              )
                            : weatherProvider.weatherData != null
                                ? WeatherDetail(
                                    weather: weatherProvider.weatherData!,
                                  )
                                : const Text(
                                    "Data Loading...",
                                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Xin chào @name',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

    );
  }
}
