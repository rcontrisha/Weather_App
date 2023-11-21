import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  static const String apiKey = '3bf33a405be0c8c65fa6ac8a4a384162'; // OpenWeatherMap API key

  static Future<Map<String, dynamic>> getWeatherData(String city) async {
    final String baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
    final Uri uri = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric&lang=id');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }

  static Future<Map<String, dynamic>> getForecastData(String city) async {
    final String baseUrl = 'http://api.openweathermap.org/data/2.5/forecast';
    final Uri uri = Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric&lang=id');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch forecast data');
    }
  }
}
