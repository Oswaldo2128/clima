import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() => runApp(const MyApp());

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
  const apiKey = '1142a9567150c9e455cd4f5ba89953a6';
  // const cityName = 'Zitacuaro';
  // const url =
  //     'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

  final url =
      'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

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
  String _locationMessage = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _getCurrentLocation()
        .then((data) => {
              fetchWeather(data[0], data[1]).then((data) {
                setState(() {
                  weatherData = data;
                  isLoading = false;
                });
              }).catchError((error) {
                setState(() {
                  isLoading = false;
                });
              })
            })
        .catchError((error) {
      setState(() {
        isLoading = false;
      });
    });

    ;
  }

    Future<List<double>> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    List<double> location = [];

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = 'El servicio de ubicación está deshabilitado.';
      });
      return location;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = 'Los permisos de ubicación están denegados.';
        });
        return location;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage =
            'Los permisos de ubicación están denegados permanentemente.';
      });
      return location;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return location = [position.latitude, position.longitude];
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      Home(weatherData: weatherData, locationMessage: _locationMessage),
      const Forecast(),
      const Search(),
      const Configurations()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(),
      ),
      body: Center(
        child: widgetOptions[_selectedIndex],
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
  final String locationMessage;

  const Home({super.key, this.weatherData, required this.locationMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(locationMessage),
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
    return const Column(
      children: <Widget>[
        Text('Index 1: Forecast'),
      ],
    );
  }
}

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Text('Index 2: Search'),
      ],
    );
  }
}

class Configurations extends StatelessWidget {
  const Configurations({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Text('Index 3: Configurations'),
      ],
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
