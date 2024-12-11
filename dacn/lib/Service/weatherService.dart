import 'dart:convert';
import 'package:dacn/Model/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = "befe89839e80e0a7c1ecdf5708af00ab";

  Future<WeatherData?> fetchWeather() async {
    try {
      // Request location
      Position position = await _determinePosition();
      print("Current Position: $position");

      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather"
          "?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey",
        ),
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        print('Failed to load Weather data: ${response.statusCode}');
        return null; // Hoặc ném ra Exception nếu bạn muốn
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  // Method to determine position
  Future<Position> _determinePosition() async {
    // Check if location services are enabled
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // If permissions are granted, continue to get the position
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
