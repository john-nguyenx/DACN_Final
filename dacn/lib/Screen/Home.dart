
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
<<<<<<< Updated upstream
<<<<<<< HEAD
<<<<<<< HEAD
=======


  
>>>>>>> parent of 42ce239 (Server)
=======


  
>>>>>>> parent of 42ce239 (Server)
=======
  

  @override
  void initState() {
    super.initState();
    // Load weather data after the first frame is built.

      WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeatherData();
    });
  }
  
  Future<void> _fetchWeatherData() async {
    final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    await weatherProvider.fetchWeather(); // Fetch weather data from provider
  }
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RefreshIndicator(
        onRefresh: _fetchWeatherData, // Call fetchWeather when refreshed
        child: ListView( // Use ListView to enable scrolling
          children: [
            // Weather Information
            SizedBox(
              height: 105,
              child: Row(
                children: [
                  Center(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}