import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Icon(
          Icons.cloud,
          color: Color.fromARGB(255, 255, 255, 255),
          size: 30.0,
        ),
        SizedBox(width: 20),
        Text('Weather app'),
      ],
    );
  }
}
