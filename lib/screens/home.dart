import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const Home({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Temperatura: ${weatherData?['main']['temp'] ?? 'Cargando...'}°C'),
        Text(
            'Clima: ${weatherData?['weather'][0]['description'] ?? 'Cargando...'}'),
        Text('Humedad: ${weatherData?['main']['humidity'] ?? 'Cargando...'}%'),
      ],
    );
  }
}
