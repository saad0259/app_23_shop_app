import 'package:app_23_shop_app/provider/cart.dart' show Cart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../provider/orders.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future(() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final snackBar = SnackBar(content: Text('Swipe Left to Delete Items'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cartData.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).orderNow(
                          cartData.items.values.toList(), cartData.totalAmount);
                      cartData.clearCart();
                    },
                    child: Text(
                      'Order Now',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cartData.itemCount,
            itemBuilder: (ctx, i) => CartItem(
                productId: cartData.items.keys.toList()[i],
                id: cartData.items.values.toList()[i].id,
                title: cartData.items.values.toList()[i].title,
                price: cartData.items.values.toList()[i].price,
                quantity: cartData.items.values.toList()[i].quantity),
          ))
        ],
      ),
    );
  }
}
