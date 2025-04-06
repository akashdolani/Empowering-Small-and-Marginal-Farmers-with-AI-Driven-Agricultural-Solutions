// weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static String apiKey = dotenv.env['WEATHER_API_KEY'] ?? 'DEFAULT_API_KEY';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const String forecastUrl = 'https://api.openweathermap.org/data/2.5/forecast';

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final url = '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Get humidity directly from the current weather data
      final humidity = data['main']['humidity'].toDouble();

      // Get rainfall data from forecast API
      final rainfall = await _fetchRainfall(lat, lon);

      return {
        "temperature": data['main']['temp'],
        "description": data['weather'][0]['description'],
        "humidity": humidity,      // Added humidity data
        "rainfall": rainfall,      // Added rainfall data
      };
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<double> _fetchRainfall(double lat, double lon) async {
    try {
      final url = '$forecastUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List forecastList = data['list'];

        // Calculate total rainfall for the next 24 hours (8 data points if 3-hour steps)
        double totalRainfall = 0.0;

        // Take up to 8 forecast points (24 hours if 3-hour intervals)
        int pointsToCheck = forecastList.length > 8 ? 8 : forecastList.length;

        for (int i = 0; i < pointsToCheck; i++) {
          // Check if rain data exists and extract the value
          if (forecastList[i].containsKey('rain')) {
            // The '3h' key means rainfall in mm for 3 hours
            if (forecastList[i]['rain'].containsKey('3h')) {
              totalRainfall += forecastList[i]['rain']['3h'];
            }
          }
        }

        // If no rainfall data found, use a reasonable default
        return totalRainfall > -1 ? totalRainfall : 60.0;
      } else {
        return 20.0; // Default rainfall value in mm
      }
    } catch (e) {
      print('Error fetching rainfall data: $e');
      return 20.0; // Default rainfall value in mm
    }
  }
}