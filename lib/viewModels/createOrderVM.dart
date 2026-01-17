import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product.dart';

/// ViewModel que gestiona la lógica de negocio para la pantalla de crear pedido.
/// Utiliza ChangeNotifier para notificar a la vista sobre cambios de estado.
class CreateOrderViewModel extends ChangeNotifier {
  String _tableName = "";
  List<Product> _selectedProducts = [];

  String get tableName => _tableName;
  List<Product> get selectedProducts => _selectedProducts;

  /// Calcula el precio total temporal de los productos seleccionados actualmente.
  double get totalTempPrice {
    return _selectedProducts.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// Establece el nombre de la mesa y notifica.
  void setTableName(String name) {
    _tableName = name;
    notifyListeners();
  }

  /// Actualiza la lista de productos seleccionados y refresca la interfaz.
  void updateProducts(List<Product> products) {
    _selectedProducts = products;
    notifyListeners();
  }

  /// Valida el pedido.
  /// Retorna true si hay un nombre de mesa y al menos un producto.
  bool get isValid {
    return _tableName.isNotEmpty && _selectedProducts.isNotEmpty;
  }

  /// Genera una instancia final del pedido con los datos actuales del ViewModel.
  Order createOrder() {
    return Order(
      tableName: _tableName,
      // Creamos una copia de la lista para evitar referencias mutables no deseadas
      products: List.from(_selectedProducts),
    );
  }
}