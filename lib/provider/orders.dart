import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

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
  final String authToken;
  final String userId;

  Orders(this._orders, this.authToken, this.userId);



  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {

    final Uri ordersUrl = Uri.parse(
        'https://cloudmart-ecommerce-default-rtdb.firebaseio.com/orders/$userId/.json?auth=$authToken');
    final response = await http.get(ordersUrl);
    final List<OrderItem> _loadedOrders = [];
    if (response == null) {
      return;
    }

    var responseData = jsonDecode(response.body);

    if (responseData == null) {
      return;
    }
    responseData= responseData  as Map<String, dynamic>;

    responseData.forEach((orderId, orderData) {
      _loadedOrders.add(OrderItem(
        id: orderId,
        price: orderData['price'],
        dateTime: DateTime.parse(
          orderData['dateTime'],
        ),
        product: (orderData['products'] as List<dynamic>)
            .map((e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ))
            .toList(),
      ));
    });
    _orders = _loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> orderNow(List<CartItem> cartProducts, double total) async {
    if (cartProducts.isEmpty) {
      return;
    }
    final dateTime = DateTime.now();
    final Uri ordersUrl = Uri.parse(
        'https://cloudmart-ecommerce-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');

    try {
      final response = await http.post(ordersUrl,
          body: jsonEncode({
            'price': total,
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'price': e.price,
                      'quantity': e.quantity,
                    })
                .toList(),
            'dateTime': dateTime.toIso8601String(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: jsonDecode(response.body)['name'],
          price: total,
          product: cartProducts,
          dateTime: dateTime,
        ),
      );

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
