import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize();
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
