import 'package:flutter/material.dart';
import 'views/screens/homeScreen.dart';
import 'views/screens/orderResumeScreen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bar Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      
      home: const HomeScreen(),

      routes: {
        '/resumen': (context) => const OrderResumeScreen(),
      },
    );
  }
}