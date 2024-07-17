import 'package:app_clima/screens/Configurations.dart';
import 'package:app_clima/screens/Forecast.dart';
import 'package:app_clima/screens/Search.dart';
import 'package:app_clima/screens/home.dart';
import 'package:app_clima/utils/weather_api.dart';
import 'package:app_clima/widgets/Navigation.dart';
import 'package:app_clima/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alerta"),
            content: const Text("El servicio de ubicación está deshabilitado."),
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
      throw Exception('El servicio de ubicación está deshabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Alerta"),
              content: const Text("Los permisos de ubicación están denegados."),
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
        throw Exception('Los permisos de ubicación están denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alerta"),
            content: const Text(
                "Los permisos de ubicación están denegados permanentemente."),
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
