import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product.dart';

class HomeViewModel extends ChangeNotifier {
  List<Order> orders = [];

  HomeViewModel() {
    _loadInitialData();
  }

  void _loadInitialData() {
    orders.addAll([
      Order(
        tableName: "Mesa 1 (Terraza)",
        products: [
          Product(name: "Vermut Casero", price: 2.50, quantity: 2),
          Product(name: "Gilda", price: 1.20, quantity: 2),
          Product(name: "Chipirones", price: 8.50, quantity: 1),
        ],
      ),
      Order(
        tableName: "Mesa 2 (Interior)",
        products: [
          Product(name: "Solomillo al Whisky", price: 11.50, quantity: 1),
          Product(name: "Huevos Rotos", price: 9.00, quantity: 1),
          Product(name: "Copa de Rioja", price: 3.00, quantity: 2),
        ],
      ),
      Order(
        tableName: "Mesa 3 (Ventana)",
        products: [
          Product(name: "Ración de Paella", price: 12.00, quantity: 3),
          Product(name: "Pan con Tomate", price: 3.50, quantity: 2),
          Product(name: "Clara de Limón", price: 2.20, quantity: 3),
        ],
      ),
      Order(
        tableName: "Mesa 4 (Barra)",
        products: [
          Product(name: "Pimientos de Padrón", price: 5.50, quantity: 1),
          Product(name: "Lacón a la Gallega", price: 10.00, quantity: 1),
          Product(name: "Gin Tonic", price: 7.00, quantity: 1),
        ],
      ),
      Order(
        tableName: "Mesa 5 (Privado)",
        products: [
          Product(name: "Tiramisú", price: 5.00, quantity: 2),
          Product(name: "Coulant de Chocolate", price: 5.50, quantity: 1),
          Product(name: "Cortado", price: 1.30, quantity: 3),
        ],
      ),
    ]);

    notifyListeners();
  }

  void addOrder(Order order) {
    orders.add(order);
    notifyListeners();
  }
}