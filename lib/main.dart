import 'package:app_23_shop_app/provider/auth.dart';
import 'package:app_23_shop_app/screens/auth_screen.dart';
import 'package:app_23_shop_app/screens/cart_screen.dart';
import 'package:app_23_shop_app/screens/edit_product_screen.dart';
import 'package:app_23_shop_app/screens/orders_screen.dart';
import 'package:app_23_shop_app/screens/splash_screen.dart';
import 'package:app_23_shop_app/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_details.dart';
import './screens/products_gallery.dart';

import './provider/products_provider.dart';
import './provider/cart.dart';
import './provider/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, previousProducts) => ProductsProvider(
              auth.token == null ? '' : auth.token!,
              auth.userId ?? '',
              previousProducts == null ? [] : previousProducts.items),
          create: (_) => ProductsProvider('', '', []),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders(
              previousOrders?.orders == null ? [] : previousOrders!.orders,
              auth.token == null ? '' : auth.token!,
              auth.userId ?? ''),
          create: (ctx) => Orders([], '', ''),
        ),
      ],
      // value: ProductsProvider(),
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: authData.isAuth
              ? ProductsGallery()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetails.routeName: (ctx) => ProductDetails(),
            ProductsGallery.routeName: (ctx) => ProductsGallery(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
