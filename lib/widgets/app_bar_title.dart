import 'package:flutter/material.dart';

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
