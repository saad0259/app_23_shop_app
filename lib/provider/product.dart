import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  Uri parameterUrl(String id) {
    final Uri url = Uri.parse(
        'https://cloudmart-ecommerce-default-rtdb.firebaseio.com/products/$id.json');
    return url;
  }

  Future<void> toggleFavorite(String id) async {
    final url = parameterUrl(id);
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.patch(url,
          body: jsonEncode({
            'isFavorite': isFavorite,
          }));
    } catch (error) {
      isFavorite = !isFavorite;
      throw error;
    } finally {
      notifyListeners();
    }
  }
}
