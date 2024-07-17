import 'package:flutter/material.dart';
import 'screens/my_home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Weather app';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: const MyHomePage(title: appTitle),
      darkTheme: ThemeData.dark(),
    );
  }
}
