import 'package:flutter/material.dart';
import 'views/screens/homeScreen.dart';
import 'views/screens/orderResumeScreen.dart';

void main() {
  runApp(const BarApp());
}

/// Clase principal de la aplicación.
class BarApp extends StatelessWidget {
  const BarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Bar',
      // Definición del tema visual de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      // Pantalla inicial de la aplicación
      home: const HomeScreen(),
      // Mapa de rutas para la navegación con nombres
      routes: {
        '/resumen': (context) => const OrderResumeScreen(),
      },
    );
  }
}