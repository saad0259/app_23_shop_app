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
  final String authToken, userId;

  ProductsProvider(
    this.authToken,
    this.userId,
    this._items,
  );

  Uri parameterUrl(String id) {
    final Uri url = Uri.parse(
        'https://cloudmart-ecommerce-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    return url;
  }

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

  Future<void> fetchAndSetProducts([bool filterByUserId = false]) async {
    final filterString =
        filterByUserId ? 'orderBy="userId"&equalTo="$userId"' : '';

    final Uri productsUrl = Uri.parse(
        'https://cloudmart-ecommerce-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    final Uri favoriteStatusUrl = Uri.parse(
        'https://cloudmart-ecommerce-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
    try {
      final _response = await http.get(productsUrl);
      final _responseData = json.decode(_response.body) as Map<String, dynamic>;
      if (_responseData == null) {
        return;
      }

      final favoriteStatus = await http.get(favoriteStatusUrl);
      final favoriteData = jsonDecode(favoriteStatus.body);

      final List<Product> loadedProducts = [];
      _responseData.forEach((prodId, prodData) {
        var _favStatus;
        if (favoriteData == null) {
          _favStatus = false;
        } else {
          _favStatus = favoriteData[prodId] == null
              ? false
              : favoriteData[prodId] ?? false;
        }

        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite: _favStatus,

            // isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addProduct(Product product) async {
    final Uri productsUrl = Uri.parse(
        'https://cloudmart-ecommerce-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(productsUrl,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'userId': userId,
            // 'isFavorite': product.isFavorite,
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final Uri url = parameterUrl(id);
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
        _items[productIndex] = newProduct;
        notifyListeners();
      } catch (error) {}
    } else {}
  }

  Future<void> deleteProduct(String prodId) async {
    final Uri url = parameterUrl(prodId);

    final _existingProductIndex =
        _items.indexWhere((element) => element.id == prodId);
    Product? _existingProduct = _items[_existingProductIndex];
    _items.removeAt(_existingProductIndex);
    notifyListeners();
    try {
      await http.delete(url);
    } catch (error) {
      _items.insert(_existingProductIndex, _existingProduct);
      throw error;
    } finally {
      _existingProduct = null;
      notifyListeners();
    }
  }
}
