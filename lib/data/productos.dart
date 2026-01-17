import '../models/product.dart';

/// Clase proveedora de datos simulados.
/// Se utiliza para poblar la lista de productos disponibles sin necesidad de un backend real.
class MockData {
  static List<Product> getCarta() {
    return [
      Product(name: "Vermut Casero", price: 2.50),
      Product(name: "Gilda", price: 1.20),
      Product(name: "Pan con Tomate", price: 3.50),
      Product(name: "Chipirones", price: 8.50),
      Product(name: "Huevos Rotos", price: 9.00),
      Product(name: "Solomillo al Whisky", price: 11.50),
      Product(name: "Pimientos de Padrón", price: 5.50),
      Product(name: "Lacón a la Gallega", price: 10.00),
      Product(name: "Ración de Paella", price: 12.00),
      Product(name: "Copa de Rioja", price: 3.00),
      Product(name: "Clara de Limón", price: 2.20),
      Product(name: "Tiramisú", price: 5.00),
      Product(name: "Coulant de Chocolate", price: 5.50),
      Product(name: "Gin Tonic", price: 7.00),
      Product(name: "Cortado", price: 1.30),
    ];
  }
}