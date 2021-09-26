import 'package:flutter/material.dart';

import '../models/product.dart';

import '../widgets/product_item.dart';

class ProductsGallery extends StatelessWidget {
  final List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://media.istockphoto.com/photos/pants-isolated-on-white-backgroundfashion-men-trousers-picture-id1283022436?b=1&k=6&m=1283022436&s=170667a&w=0&h=KGUyT95P6Znsbq4fYg6ybF_Q-WHMv4FhuMcsyZh7QVE='),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Mart'),
      ),
      body: GridView.builder(
          itemCount: _products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (ctx, i) => ProductItem(
                id: _products[i].id,
                title: _products[i].title,
                imageUrl: _products[i].imageUrl,
              )),
    );
  }
}
