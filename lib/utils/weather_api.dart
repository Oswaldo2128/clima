import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '1142a9567150c9e455cd4f5ba89953a6';

Future<Map<String, dynamic>?> getWeatherCurrent(double lat, double lon) async {
  final url =
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al cargar el clima');
  }
}

Future<Map<String, dynamic>?> getWeatherOfCity(String cityName) async {
  final url =
      'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al cargar el clima');
  }
}
