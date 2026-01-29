import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AirWordApp());
}

class AirWordApp extends StatelessWidget {
  const AirWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirWord',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
