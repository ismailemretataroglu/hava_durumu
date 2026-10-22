import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  await initializeDateFormatting('tr_TR');
  runApp(const HavaDurumuApp());
}

class HavaDurumuApp extends StatelessWidget {
  const HavaDurumuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE9E2D6),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF24433A)),
      ),
      home: const HomeScreen(),
    );
  }
}
