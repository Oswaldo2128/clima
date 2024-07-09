import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

const apiKey = '1142a9567150c9e455cd4f5ba89953a6';

void main() => runApp(const MyApp());

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Clima';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  Map<String, dynamic>? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _fetchWeatherData() async {
    try {
      List<double> data = await _getCurrentLocation();
      if (data.isNotEmpty) {
        Map<String, dynamic>? weather =
            await getWeatherCurrent(data[0], data[1]);
        if (mounted) {
          setState(() {
            weatherData = weather;
            isLoading = false;
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Alerta"),
                content: const Text("Error, intente mas tarde"),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
      }
    }
  }

  Future<List<double>> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('El servicio de ubicación está deshabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación están denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Los permisos de ubicación están denegados permanentemente.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return [position.latitude, position.longitude];
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      Home(weatherData: weatherData),
      const Forecast(),
      const Search(),
      const Configurations()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : widgetOptions[_selectedIndex],
      ),
      drawer: Navigation(
          selectedIndex: _selectedIndex, onItemTapped: _onItemTapped),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Icon(
          Icons.cloud,
          color: Color.fromARGB(255, 11, 98, 197),
          size: 30.0,
        ),
        SizedBox(width: 8),
        Text('Clima'),
      ],
    );
  }
}

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

class Forecast extends StatelessWidget {
  const Forecast({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Index 1: Forecast'),
    );
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Index 2: Search'),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Ingresa el nombre de la ciudad',
              ),
              validator: (String? value) {
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {}
              },
              child: const Text('Buscar'),
            ),
          ),
        ],
      ),
    );
  }
}

class Configurations extends StatelessWidget {
  const Configurations({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Index 3: Configurations'),
    );
  }
}

class Navigation extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const Navigation(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://img.freepik.com/foto-gratis/agricultura-inteligente-agricultura-iot_53876-124634.jpg?t=st=1720227092~exp=1720230692~hmac=aeed634f5f5b991456236f316f410042573a0485b0ab5dbabf75e345b6235cd3&w=996'),
                fit: BoxFit.cover,
              ),
            ),
            child: null,
          ),
          ListTile(
            title: const Text('Home'),
            selected: selectedIndex == 0,
            onTap: () {
              onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Forecast'),
            selected: selectedIndex == 1,
            onTap: () {
              onItemTapped(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Search'),
            selected: selectedIndex == 2,
            onTap: () {
              onItemTapped(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Configurations'),
            selected: selectedIndex == 3,
            onTap: () {
              onItemTapped(3);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
