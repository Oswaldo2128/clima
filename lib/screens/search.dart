import 'package:app_clima/utils/weather_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  Map<String, dynamic>? weatherData;
  bool flag = false;
  String? desc = "";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Ingresa el nombre de la ciudad',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre de la ciudad';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    weatherData =
                        await getWeatherOfCity(_controller.text, context);
                    setState(() {
                      if (weatherData != null) {
                        desc = toBeginningOfSentenceCase(
                            weatherData?['weather']?[0]['description']);
                        flag = true;
                      } else {
                        flag = false;
                      }
                    });
                  }
                },
                child: const Text('Buscar'),
              ),
            ),
            Expanded(
              child: !flag
                  ? const Center(child: Text('Sin información'))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(desc ?? 'Cargando...'),
                        const SizedBox(height: 5.0),
                        weatherData?['weather']?[0]['icon'] != null
                            ? Image.network(
                                'https://openweathermap.org/img/wn/${weatherData?['weather'][0]['icon']}@2x.png')
                            : const Text('Cargando...'),
                        const SizedBox(height: 5.0),
                        Text(
                            '${weatherData?['main']['temp'] ?? 'Cargando...'} °C'),
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
                            const SizedBox(width: 5.0),
                            Text(
                                '${weatherData?['visibility'] / 1000 ?? 'Cargando...'} km'),
                            const SizedBox(width: 50.0),
                            const Icon(
                              Icons.speed,
                              color: Color.fromARGB(255, 0, 0, 0),
                              size: 30.0,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                                '${weatherData?['wind']['speed'] ?? 'Cargando...'} m/s'),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                            '${weatherData?['name'] ?? 'Cargando...'}, ${weatherData?['sys']['country'] ?? 'Cargando...'}'),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
