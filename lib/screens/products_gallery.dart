import 'package:app_23_shop_app/provider/cart.dart';
import 'package:app_23_shop_app/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOption { Favorites, All }

class ProductsGallery extends StatefulWidget {
  @override
  _ProductsGalleryState createState() => _ProductsGalleryState();
}

class _ProductsGalleryState extends State<ProductsGallery> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    // final _products = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Mart'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites Only'),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOption.All,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cartData, ch) => Badge(
                child: ch!,
                value: cartData.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
