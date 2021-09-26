import 'package:app_23_shop_app/screens/product_details.dart';
import 'package:app_23_shop_app/screens/products_gallery.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      // home: ProductsGallery(),
      routes: {
        '/' : (ctx) => ProductsGallery(),
        ProductDetails.routeName: (ctx) => ProductDetails(),
      },
    );
  }
}
