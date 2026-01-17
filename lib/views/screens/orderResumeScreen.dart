import 'package:flutter/material.dart';
import '../../models/order.dart';

/// Pantalla de resumen de un pedido.
/// Muestra el detalle de la mesa, la lista de productos y el total final.
/// Se utiliza tanto para previsualizar antes de crear como para ver detalles de pedidos ya creados.
class OrderResumeScreen extends StatelessWidget {
  const OrderResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Order;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Resumen Final"),
        backgroundColor: Colors.blue[700],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mesa: ${order.tableName}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Divider(),
            const Text("Productos:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: order.products.length,
                itemBuilder: (context, index) {
                  final p = order.products[index];
                  return Card(
                    color: Colors.blue[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 4),
                    child: ListTile(
                      title: Text(p.name),
                      subtitle: Text("Cantidad: ${p.quantity}"),
                      trailing: Text(
                          "${(p.price * p.quantity).toStringAsFixed(2)} €",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "TOTAL: ${order.totalOrderPrice.toStringAsFixed(2)} €",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Volver a edición",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
