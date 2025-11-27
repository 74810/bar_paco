import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/product.dart';

class HomeViewModel extends ChangeNotifier {
  List<Order> orders = [];

  HomeViewModel() {
    _loadInitialData();
  }

  void _loadInitialData() {
    orders.add(
      Order(
        tableName: "Mesa 1 (Demo)",
        products: [
          Product(name: "Caña", price: 1.50, quantity: 2),
          Product(name: "Bravas", price: 4.50, quantity: 1),
        ],
      ),
    );
    notifyListeners();
  }

  void addOrder(Order order) {
    orders.add(order);
    notifyListeners();
  }
}