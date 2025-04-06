// weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = '1e8ce387964c7742bf454f69c3aff996'; // Replace with your API key
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