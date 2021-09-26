import '../provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products= productData.items;


    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (ctx, i) =>
            ProductItem(
              id: products[i].id,
              title: products[i].title,
              imageUrl: products[i].imageUrl,
            ));

  }
}
