import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// 1. MODELOS (DATA LAYER)
// ---------------------------------------------------------------------------

class Producto {
  final String id;
  final String nombre;
  final double precio;

  Producto({required this.id, required this.nombre, required this.precio});
}

class LineaPedido {
  final Producto producto;
  int cantidad;

  LineaPedido({required this.producto, this.cantidad = 1});

  double get total => producto.precio * cantidad;
}

class Pedido {
  final String mesa;
  final List<LineaPedido> lineas;

  Pedido({required this.mesa, required this.lineas});

  int get totalProductos => lineas.fold(0, (sum, item) => sum + item.cantidad);
  double get totalPrecio => lineas.fold(0.0, (sum, item) => sum + item.total);
}

// ---------------------------------------------------------------------------
// 2. VIEW MODELS (MVVM - Lógica de Negocio y Estado)
// ---------------------------------------------------------------------------

// ViewModel para la Home (Lista de Pedidos)
class HomeViewModel extends ChangeNotifier {
  List<Pedido> pedidos = [];

  HomeViewModel() {
    _cargarDatosIniciales();
  }

  void _cargarDatosIniciales() {
    // Requisito: "inicialmente tienen que existir pedidos"
    pedidos.add(Pedido(
      mesa: "Mesa 1 (Demo)",
      lineas: [
        LineaPedido(producto: Producto(id: '1', nombre: 'Caña', precio: 1.50), cantidad: 2),
      ],
    ));
    notifyListeners();
  }

  void agregarPedido(Pedido pedido) {
    pedidos.add(pedido);
    notifyListeners();
  }
}

// ViewModel para Crear Pedido
class CreateOrderViewModel extends ChangeNotifier {
  String mesa = "";
  List<LineaPedido> lineas = [];

  void setMesa(String valor) {
    mesa = valor;
    notifyListeners();
  }

  void actualizarProductos(List<LineaPedido> nuevosProductos) {
    // Lógica simple: Reemplazamos o agregamos. Aquí agregamos al listado actual.
    // Para simplificar el ejercicio, si devuelve una lista, la usamos como la actual.
    lineas = nuevosProductos;
    notifyListeners();
  }

  double get totalAcumulado => lineas.fold(0.0, (sum, item) => sum + item.total);
  bool get esValido => mesa.isNotEmpty && lineas.isNotEmpty;

  Pedido? generarPedido() {
    if (!esValido) return null;
    return Pedido(mesa: mesa, lineas: List.from(lineas));
  }
}

// ---------------------------------------------------------------------------
// 3. CATALOGO DE DATOS (Simulado)
// ---------------------------------------------------------------------------

final List<Producto> cartaDelBar = [
  Producto(id: '1', nombre: 'Caña', precio: 1.50),
  Producto(id: '2', nombre: 'Pinta', precio: 3.00),
  Producto(id: '3', nombre: 'Vino Tinto', precio: 2.50),
  Producto(id: '4', nombre: 'Refresco', precio: 2.00),
  Producto(id: '5', nombre: 'Bravas', precio: 4.50),
  Producto(id: '6', nombre: 'Croquetas', precio: 5.00), // Requisito: Al menos 6 productos
  Producto(id: '7', nombre: 'Sepia', precio: 7.50),
];

// ---------------------------------------------------------------------------
// 4. VISTAS (UI LAYER)
// ---------------------------------------------------------------------------

void main() {
  runApp(const BarApp());
}

class BarApp extends StatelessWidget {
  const BarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bar Flutter MVVM',
      theme: ThemeData(primarySwatch: Colors.indigo),
      // Requisito: Definir ruta con nombre para el resumen
      routes: {
        '/': (context) => const HomeScreen(),
        '/resumen': (context) => const SummaryScreen(),
      },
      initialRoute: '/',
    );
  }
}

// --- PANTALLA PRINCIPAL (HOME) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instanciamos el VM. En una app grande usaríamos Provider/Riverpod.
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pedidos del Bar")),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          if (_viewModel.pedidos.isEmpty) {
            return const Center(child: Text("No hay pedidos activos"));
          }
          return ListView.builder(
            itemCount: _viewModel.pedidos.length,
            itemBuilder: (context, index) {
              final pedido = _viewModel.pedidos[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: Text(pedido.mesa),
                  subtitle: Text("${pedido.totalProductos} productos"),
                  trailing: Text("${pedido.totalPrecio.toStringAsFixed(2)} €",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Nuevo Pedido"),
        icon: const Icon(Icons.add),
        onPressed: _irACrearPedido,
      ),
    );
  }

  // Requisito: Navegación Imperativa y comprobar mounted al volver
  Future<void> _irACrearPedido() async {
    // Navegación imperativa (push)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
    );

    // Requisito: Comprobar mounted antes de usar setState o lógica de UI
    if (!mounted) return;

    if (result != null && result is Pedido) {
      // Requisito: Al volver con pedido guardado, se añade y recalcula
      _viewModel.agregarPedido(result);
    }
  }
}

// --- PANTALLA CREAR PEDIDO ---
class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final CreateOrderViewModel _viewModel = CreateOrderViewModel();
  final TextEditingController _mesaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mesaController.addListener(() {
      _viewModel.setMesa(_mesaController.text);
    });
  }

  @override
  void dispose() {
    _mesaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Pedido")),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _mesaController,
                  decoration: const InputDecoration(
                    labelText: "Mesa o Nombre",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: _viewModel.lineas.isEmpty
                    ? const Center(child: Text("Sin productos seleccionados"))
                    : ListView.builder(
                        itemCount: _viewModel.lineas.length,
                        itemBuilder: (context, index) {
                          final linea = _viewModel.lineas[index];
                          return ListTile(
                            title: Text(linea.producto.nombre),
                            subtitle: Text("${linea.cantidad} x ${linea.producto.precio} €"),
                            trailing: Text("${linea.total.toStringAsFixed(2)} €"),
                          );
                        },
                      ),
              ),
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("TOTAL:", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${_viewModel.totalAcumulado.toStringAsFixed(2)} €",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _irASeleccionProductos,
                      child: const Text("Añadir Productos"),
                    ),
                    // Requisito: Botón "Ver resumen" usando rutas con nombre
                    ElevatedButton(
                      onPressed: _viewModel.lineas.isNotEmpty ? _irAResumen : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                      child: const Text("Ver Resumen"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                         // Requisito: Cancelar hace pop sin devolver nada
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: _guardarPedido,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text("Guardar Pedido"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _irASeleccionProductos() async {
    // Requisito: Navegación con push para elegir productos
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectProductsScreen(),
      ),
    );

    // Requisito: Comprobar mounted
    if (!mounted) return;

    if (result != null && result is List<LineaPedido>) {
      _viewModel.actualizarProductos(result);
    }
  }

  void _irAResumen() {
    // Requisito: Validación básica antes de ir al resumen
    if (!_viewModel.esValido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Introduce una mesa y productos para ver el resumen")),
      );
      return;
    }

    // Requisito: Navegación con rutas con nombre (pushNamed)
    final pedidoTemp = _viewModel.generarPedido();
    Navigator.pushNamed(context, '/resumen', arguments: pedidoTemp);
  }

  void _guardarPedido() {
    // Requisito: Validaciones (Mesa válida y productos existen)
    if (!_viewModel.esValido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Falta el nombre de la mesa o productos")),
      );
      return;
    }
    // Requisito: Pop devolviendo pedido completo
    Navigator.pop(context, _viewModel.generarPedido());
  }
}

// --- PANTALLA SELECCIONAR PRODUCTOS ---
class SelectProductsScreen extends StatefulWidget {
  const SelectProductsScreen({super.key});

  @override
  State<SelectProductsScreen> createState() => _SelectProductsScreenState();
}

class _SelectProductsScreenState extends State<SelectProductsScreen> {
  // Mapa temporal para gestionar cantidades: ID -> Cantidad
  final Map<String, int> _cantidades = {};

  void _incrementar(Producto p) {
    setState(() {
      _cantidades[p.id] = (_cantidades[p.id] ?? 0) + 1;
    });
  }

  void _decrementar(Producto p) {
    setState(() {
      int current = _cantidades[p.id] ?? 0;
      if (current > 0) {
        _cantidades[p.id] = current - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seleccionar Productos")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartaDelBar.length,
              itemBuilder: (context, index) {
                final producto = cartaDelBar[index];
                final cantidad = _cantidades[producto.id] ?? 0;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(producto.nombre),
                    subtitle: Text("${producto.precio} €"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _decrementar(producto),
                        ),
                        Text(cantidad.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _incrementar(producto),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Requisito: Cancelar hace pop sin datos
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: _confirmarSeleccion,
                  child: const Text("Confirmar"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _confirmarSeleccion() {
    List<LineaPedido> seleccion = [];
    _cantidades.forEach((key, qty) {
      if (qty > 0) {
        final prod = cartaDelBar.firstWhere((p) => p.id == key);
        seleccion.add(LineaPedido(producto: prod, cantidad: qty));
      }
    });

    // Requisito: Confirmar devuelve productos seleccionados
    Navigator.pop(context, seleccion);
  }
}

// --- PANTALLA RESUMEN FINAL ---
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Recuperamos el argumento pasado por pushNamed
    final pedido = ModalRoute.of(context)!.settings.arguments as Pedido;

    return Scaffold(
      appBar: AppBar(title: const Text("Resumen del Pedido")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Requisito: Muestra mesa
            Text("Mesa: ${pedido.mesa}", style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),
            const SizedBox(height: 10),
            const Text("Productos:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: pedido.lineas.length,
                itemBuilder: (context, index) {
                  final linea = pedido.lineas[index];
                  // Requisito: Muestra productos, cantidad y total
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${linea.cantidad} x ${linea.producto.nombre}"),
                      Text("${linea.total.toStringAsFixed(2)} €"),
                    ],
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("TOTAL FINAL:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("${pedido.totalPrecio.toStringAsFixed(2)} €",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Requisito: Volver con pop sin cambios
                  Navigator.pop(context);
                },
                child: const Text("Cerrar Resumen"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}