import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final Uri productsUrl = Uri.parse(
      'https://cloudmart-ecommerce-default-rtdb.firebaseio.com/products.json');

  // var _showFavoriteOnly=false;
  //
  // void toggleShowFavourite(){
  //   _showFavoriteOnly=!_showFavoriteOnly;
  //   notifyListeners();
  // }
  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  List<Product> get items {
    // if(_showFavoriteOnly)
    //   {
    //     return _items.where((element) => element.isFavorite).toList();
    //
    //   }
    return [
      ..._items
    ]; // returning _items but as a copy instead of reference so main _items don't change
  }

  Product findById(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final _response = await http.get(productsUrl);
      final _responseData = json.decode(_response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      _responseData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items=loadedProducts;
      notifyListeners();
    } catch (error) {
      print('Could Not load products');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(productsUrl,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));

      final newProduct = Product(
          id: json.decode(response.body).toString(),
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updateProduct(String id, Product newProduct) {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('Product not found');
    }
  }

  void deleteProduct(String prodId) {
    _items.removeWhere((element) => element.id == prodId);
    notifyListeners();
  }
}
