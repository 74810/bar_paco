import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../viewModels/createOrderVM.dart';
import 'selectProductsScreen.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final CreateOrderViewModel vm = CreateOrderViewModel();
  
  final TextEditingController _tableNameController = TextEditingController();

  @override
  void dispose() {
    _tableNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Pedido")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _tableNameController,
              decoration: const InputDecoration(
                labelText: "Nombre de la Mesa",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.table_restaurant),
              ),
              onChanged: (text) {
                vm.setTableName(text);
              },
            ),
          ),

          Expanded(
            child: vm.tempProducts.isEmpty
                ? const Center(child: Text("Lista vacía. Añade productos."))
                : ListView.builder(
                    itemCount: vm.tempProducts.length,
                    itemBuilder: (ctx, i) {
                      final product = vm.tempProducts[i];
                      return ListTile(
                        title: Text(product.name),
                        trailing: Text("${product.price} €"),
                        leading: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              vm.removeProduct(i);
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Total: ${vm.totalTempPrice.toStringAsFixed(2)} €",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                SizedBox(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("AÑADIR PRODUCTOS"),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectProductsScreen(),
                        ),
                      );

                      if (result != null && result is List<Product>) {
                        setState(() {
                          vm.addProducts(result);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("CANCELAR", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () {
                          if (!vm.isValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Falta mesa o productos")),
                            );
                            return;
                          }

                          final newOrder = vm.createOrder();
                          Navigator.pop(context, newOrder);
                        },
                        child: const Text("GUARDAR", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}