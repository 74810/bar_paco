import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product.dart';

class CreateOrderViewModel extends ChangeNotifier {
  String _tableName = "";
  List<Product> _selectedProducts = [];

  String get tableName => _tableName;
  List<Product> get selectedProducts => _selectedProducts;

  double get totalTempPrice {
    return _selectedProducts.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void setTableName(String name) {
    _tableName = name;
    notifyListeners();
  }

  void updateProducts(List<Product> products) {
    _selectedProducts = products;
    notifyListeners();
  }

  bool get isValid {
    return _tableName.isNotEmpty && _selectedProducts.isNotEmpty;
  }

  Order createOrder() {
    return Order(
      tableName: _tableName,
      products: List.from(_selectedProducts),
    );
  }
}