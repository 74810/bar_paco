import 'package:flutter/material.dart';
import '../../models/order.dart';

/// Widget personalizado que representa una tarjeta de resumen de un pedido en una lista.
/// Muestra la mesa, cantidad de productos y precio total.
class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.table_bar, color: Colors.white),
        ),
        title: Text(
          order.tableName, 
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${order.totalProductCount} productos"),
        trailing: Text(
          "${order.totalOrderPrice.toStringAsFixed(2)} €",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/resumen',
            arguments: order,
          );
        },
      ),
    );
  }
}