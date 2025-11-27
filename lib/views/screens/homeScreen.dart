import 'package:flutter/material.dart';
import '../../viewModels/homeVM.dart';
import '../../models/order.dart';
import 'createOrderScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewModel vm = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: vm,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            title: const Text("Pedidos Bar Paco"),
            backgroundColor: Colors.blue[700],
          ),
          body: vm.orders.isEmpty
              ? const Center(
                  child: Text(
                    "No hay pedidos activos",
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                  ),
                )
              : ListView.builder(
                  itemCount: vm.orders.length,
                  itemBuilder: (context, index) {
                    final order = vm.orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      color: Colors.blue[100],
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.table_bar, color: Colors.white),
                        ),
                        title: Text(
                          order.tableName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Productos: ${order.totalProductCount}"),
                        trailing: Text(
                          "${order.totalOrderPrice.toStringAsFixed(2)} €",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(
              8,
              8,
              8,
              30,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () => _navigateToCreateOrder(context),
                child: const Text(
                  "Nuevo Pedido",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToCreateOrder(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
    );

    if (!mounted) return;

    if (result != null && result is Order) {
      vm.addOrder(result);
    }
  }
}
