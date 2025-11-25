import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../data/cocktails.dart';
import '../widgets/orderTile.dart';
import 'createOrderScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final demoOrder = Order(
      tableName: "Mesa 1 (Demo)",
      products: [MockData.cocktails[0], MockData.cocktails[1]],
    );
    
    setState(() {
      orders.add(demoOrder);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bar Paco - Pedidos")),
      body: Column(
        children: [
          // LISTA DE PEDIDOS
          Expanded(
            child: orders.isEmpty
                ? const Center(child: Text("No hay pedidos activos"))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return OrderTile(order: orders[index]);
                    },
                  ),
          ),

          // BOTON NUEVO PEDIDO
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blueAccent,
              ),

        onPressed: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
  );

  if (result != null && result is Order) {
    if (!mounted) return;


    setState(() {
      orders.add(result);
    });
  }
              },
              child: const Text(
                "NUEVO PEDIDO",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}