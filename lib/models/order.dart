import 'product.dart';

/// Clase que representa un pedido realizado por una mesa.
/// Contiene la información de la mesa y la lista de productos solicitados.
class Order {
  /// Identificador de la mesa.
  final String tableName;

  /// Lista de productos asociados al pedido.
  final List<Product> products;

  /// Constructor.
  Order({
    required this.tableName,
    required this.products,
  });

  /// Calcula el precio total del pedido sumando el precio * cantidad de cada producto.
  double get totalOrderPrice {
    return products.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// Calcula la cantidad total de artículos individuales en el pedido.
  int get totalProductCount {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }
}