import 'package:flutter/material.dart';
import '../../viewModels/createOrderVM.dart';
import '../../models/product.dart';
import 'selectProductsScreen.dart';
/// Pantalla para crear un nuevo pedido.
/// Permite introducir el nombre de la mesa y seleccionar productos.
class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final CreateOrderViewModel vm = CreateOrderViewModel();
  final TextEditingController _tableController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tableController.addListener(() {
      vm.setTableName(_tableController.text);
    });
  }

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: vm,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            title: const Text("Crear Pedido"),
            backgroundColor: Colors.blue[700],
            actions: [
            Tooltip(
              message: "Ir a la pantalla de selección de productos",
              child: TextButton.icon(
                onPressed: () => _navigateSelectProducts(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Añadir Productos",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _tableController,
                  decoration: const InputDecoration(
                    labelText: "Nombre de Mesa",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: vm.selectedProducts.isEmpty
                    ? const Center(
                        child: Text(
                          "Sin productos seleccionados",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: vm.selectedProducts.length,
                        itemBuilder: (ctx, i) {
                          final p = vm.selectedProducts[i];
                          return ListTile(
                            title: Text(p.name),
                            subtitle: Text("${p.quantity} x ${p.price} €"),
                            trailing: Text(
                                "${(p.price * p.quantity).toStringAsFixed(2)} €"),
                          );
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("TOTAL ACUMULADO:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${vm.totalTempPrice.toStringAsFixed(2)} €",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: vm.isValid
                                ? () => _navigateSummary(context)
                                : null,
                            child: const Text(
                              "Ver Resumen",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: () {
                              if (vm.isValid) {
                                Navigator.pop(context, vm.createOrder());
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Error: Debes indicar el nombre de la mesa y seleccionar al menos un producto."),
                                    backgroundColor: Colors.redAccent,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            child: const Tooltip(
                              message: "Finalizar y guardar el pedido actual",
                              child: Text(
                                "Guardar Pedido",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  /// Abre la pantalla de selección de productos y espera la lista de retorno.
  Future<void> _navigateSelectProducts(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectProductsScreen()),
    );

    if (!mounted) return;

    if (result != null && result is List<Product>) {
      vm.updateProducts(result);
    }
  }
  /// Navega a la pantalla de resumen pasando el pedido temporal como argumento.
  void _navigateSummary(BuildContext context) {
    final tempOrder = vm.createOrder();
    Navigator.pushNamed(
      context,
      '/resumen',
      arguments: tempOrder,
    );
  }
}
