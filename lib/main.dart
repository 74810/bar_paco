import 'package:flutter/material.dart';
import 'views/screens/homeScreen.dart';
import 'views/screens/orderResumeScreen.dart';

void main() {
  runApp(const BarApp());
}

class BarApp extends StatelessWidget {
  const BarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Bar',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/resumen': (context) => const OrderResumeScreen(),
      },
    );
  }
}