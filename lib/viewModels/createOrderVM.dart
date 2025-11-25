import '../models/product.dart';
import '../models/order.dart';

class CreateOrderViewModel {
  List<Product> tempProducts = [];
  String tableName = "";

  double get totalTempPrice {
    double sum = 0;
    for (var p in tempProducts) sum += p.price;
    return sum;
  }

  void addProducts(List<Product> products) {
    tempProducts.addAll(products);
  }

  void removeProduct(int index) {
    tempProducts.removeAt(index);
  }

  void setTableName(String name) {
    tableName = name;
  }

  bool get isValid => tableName.isNotEmpty && tempProducts.isNotEmpty;
  
  Order createOrder() {
    return Order(tableName: tableName, products: tempProducts);
  }
}