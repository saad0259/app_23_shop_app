import 'package:app_23_shop_app/provider/cart.dart';
import 'package:flutter/foundation.dart';

class OrderItem {
  final String id;
  final double price;
  final List<CartItem> product;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.price,
      required this.product,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void orderNow(List<CartItem> cartProducts, double total) {

    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        price: total,
        product: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    // _orders.add(
    //   OrderItem(
    //     id: DateTime.now().toString(),
    //     price: total,
    //     product: cartProducts,
    //     dateTime: DateTime.now(),
    //   ),
    // );
    notifyListeners();
  }
}
