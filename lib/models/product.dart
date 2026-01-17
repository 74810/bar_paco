/// Representa un producto disponible en el bar.
class Product {

  final String name;
  final double price;

  /// Cantidad de unidades de este producto.
  /// Por defecto es 0. Es mutable para permitir actualizaciones en la interfaz.
  int quantity;

  /// Constructor.
  Product({
    required this.name,
    required this.price,
    this.quantity = 0
  });
}