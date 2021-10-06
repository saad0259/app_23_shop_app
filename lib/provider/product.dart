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

  Uri parameterUrl(String id, String token, String userId) {
    final Uri url = Uri.parse(
        'https://cloudmart-ecommerce-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    return url;
  }

  Future<void> toggleFavorite(String token, String userId) async {
    final url = parameterUrl(id, token, userId);
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.put(url,
          body: jsonEncode(
            isFavorite,
          ));
    } catch (error) {
      isFavorite = !isFavorite;
      throw error;
    } finally {
      notifyListeners();
    }
  }
}
