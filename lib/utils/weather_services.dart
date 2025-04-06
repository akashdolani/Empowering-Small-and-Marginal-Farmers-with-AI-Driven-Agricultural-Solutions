// weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static String apiKey = dotenv.env['WEATHER_API_KEY'] ?? 'DEFAULT_API_KEY'; // Replace with your API key
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final url = '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "temperature": data['main']['temp'],
        "description": data['weather'][0]['description'],
      };
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}