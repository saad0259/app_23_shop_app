import 'package:app_23_shop_app/provider/product.dart';
import 'package:flutter/material.dart';
import '../screens/product_details.dart';
import 'package:provider/provider.dart';

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
              onPressed: () {
                productItem.toggleFavorite(productItem.id);
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
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
