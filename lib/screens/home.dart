import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const Home({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM d, hh:mm a').format(now);
    String? desc =
        toBeginningOfSentenceCase(weatherData?['weather']?[0]['description']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(formattedDate),
            const SizedBox(height: 5.0),
            Text(desc ?? 'Cargando...'),
            const SizedBox(height: 5.0),
            weatherData?['weather']?[0]['icon'] != null
                ? Image.network(
                    'https://openweathermap.org/img/wn/${weatherData?['weather'][0]['icon']}@2x.png')
                : const Text('Cargando...'),
            const SizedBox(height: 5.0),
            Text('${weatherData?['main']['temp'] ?? 'Cargando...'} °C'),
            const SizedBox(height: 5.0),
            Text(
                'Sensación térmica: ${weatherData?['main']['feels_like'] ?? 'Cargando...'} °C'),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Presión: ${weatherData?['main']['pressure'] ?? 'Cargando...'} hPa'),
                const SizedBox(width: 50.0),
                Text(
                    'Humedad: ${weatherData?['main']['humidity'] ?? 'Cargando...'} %'),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.remove_red_eye_outlined,
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 30.0,
                ),
                SizedBox(width: 5.0),
                Text('${weatherData?['visibility'] / 1000 ?? 'Cargando...'} km'),
                const SizedBox(width: 50.0),
                const Icon(
                  Icons.speed,
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 30.0,
                ),
                SizedBox(width: 5.0),
                Text('${weatherData?['wind']['speed'] ?? 'Cargando...'} m/s'),
              ],
            ),
            const SizedBox(height: 5.0),
            Text(
                '${weatherData?['name'] ?? 'Cargando...'}, ${weatherData?['sys']['country'] ?? 'Cargando...'}'),
          ],
        ),
      ),
    );
  }
}
