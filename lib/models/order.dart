import 'product.dart';

class Order {
  final String tableName;
  final List<Product> products;
  
  Order({
    required this.tableName,
    required this.products,
  });

  double get totalOrderPrice {
    return products.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalProductCount {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }
}