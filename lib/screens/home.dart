import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const Home({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM d, hh:mma').format(now);
    String? desc =
        toBeginningOfSentenceCase(weatherData?['weather']?[0]['description']);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(formattedDate),
        Text(desc ?? 'Cargando...'),
        weatherData?['weather']?[0]['icon'] != null
            ? Image.network(
                'https://openweathermap.org/img/wn/${weatherData?['weather'][0]['icon']}@2x.png')
            : const Text('Cargando...'),
        Text('${weatherData?['main']['temp'] ?? 'Cargando...'} °C'),
        Text(
            'Sensación térmica: ${weatherData?['main']['feels_like'] ?? 'Cargando...'} °C'),
        Text(
            'Presión: ${weatherData?['main']['pressure'] ?? 'Cargando...'} hPa'),
        Text('Humedad: ${weatherData?['main']['humidity'] ?? 'Cargando...'} %'),
        Text(
            'Visibilidad: ${weatherData?['visibility'] / 1000 ?? 'Cargando...'} km'),
        Text(
            'Velocidad: ${weatherData?['wind']['speed'] ?? 'Cargando...'} m/s'),
        Text('País: ${weatherData?['sys']['country'] ?? 'Cargando...'}'),
        Text('Ciudad: ${weatherData?['name'] ?? 'Cargando...'}'),
      ],
    );
  }
}
