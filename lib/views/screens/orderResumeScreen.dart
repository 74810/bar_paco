import 'package:flutter/material.dart';
import '../../models/order.dart';

class OrderResumeScreen extends StatelessWidget {
  const OrderResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Order;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resumen del Pedido"),
        backgroundColor: Colors.blueAccent, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mesa: ${args.tableName}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Fecha: ${args.date.toString().substring(0, 16)}"),
            const Divider(thickness: 2),

            const SizedBox(height: 10),
            const Text("Productos:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            
            Expanded(
              child: ListView.builder(
                itemCount: args.products.length,
                itemBuilder: (ctx, i) {
                  final product = args.products[i];
                  return ListTile(
                    leading: const Icon(Icons.local_drink, color: Colors.blueAccent),
                    title: Text(product.name),
                    trailing: Text("${product.price} €"),
                  );
                },
              ),
            ),
            
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("TOTAL A PAGAR:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                    "${args.totalOrderPrice.toStringAsFixed(2)} €",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),

            //volver
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("VOLVER A EDICIÓN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}