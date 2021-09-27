import '../provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  // const ProductGrid({Key? key}) : super(key: key);

  ProductGrid({required this.showOnlyFavorites});

  final bool showOnlyFavorites;

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final products = showOnlyFavorites?productData.favoriteItems:productData.items;

    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              // create: (ctx) => products[i],
              value: products[i],
              child: ProductItem(
                  // id: products[i].id,
                  // title: products[i].title,
                  // imageUrl: products[i].imageUrl,
                  ),
            ));
  }
}
