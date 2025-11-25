import 'product.dart';

class Order {
  final String tableName;
  final List<Product> products; 
  final DateTime date;           

  Order({
    required this.tableName,
    required this.products,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  double get totalOrderPrice {
    double sum = 0;
    for (var product in products) {
      sum += product.price;
    }
    return sum;
  }

  int get totalProductCount => products.length;
}