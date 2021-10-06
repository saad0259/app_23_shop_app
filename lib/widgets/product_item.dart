import 'package:app_23_shop_app/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/product.dart';
import '../screens/product_details.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem(
  //     {Key? key, required this.id, required this.title, required this.imageUrl})
  //     : super(key: key);

  // final String id, title, imageUrl;

  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context,
        listen:
            false); // listen:true (which is default) rebuilds everything, Use Consumer Method to rebuild specific portion of the widget or refactor the widget that changes.
    final cartItem = Provider.of<Cart>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetails.routeName,
              arguments: productItem.id,
            );
          },
          child: Image.network(
            productItem.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                productItem.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                try {
                  await productItem.toggleFavorite(
                      authData.token.toString(), authData.userId!);
                  scaffoldMessenger.showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Favorite status changed.'),
                  ));
                } catch (error) {
                  scaffoldMessenger.showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Could not change favorite status.'),
                  ));
                }
              },
            ),
          ),
          title: FittedBox(
            child: Text(
              productItem.title,
              textAlign: TextAlign.center,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cartItem.addItem(
                  productItem.id, productItem.price, productItem.title);
              // Scaffold.of(context).openDrawer(); //Open the drawer with this method
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added Item to Cart!'),
                  // backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      cartItem.removeSingleItem(productItem.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
