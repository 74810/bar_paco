import '../models/product.dart';

class MockData {
  static List<Product> getCarta() {
    return [
      Product(name: "Caña", price: 1.50),
      Product(name: "Pinta", price: 3.00),
      Product(name: "Vino Tinto", price: 2.50),
      Product(name: "Refresco", price: 2.00),
      Product(name: "Bravas", price: 4.50),
      Product(name: "Croquetas", price: 5.00),
      Product(name: "Sepia", price: 7.50),
      Product(name: "Mojito", price: 6.00),
    ];
  }
}