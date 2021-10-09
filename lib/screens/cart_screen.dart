import '../provider/cart.dart' show Cart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart-screen';

  // @override
  // void initState() { // Show snackBar at page load.
  //   super.initState();
  //
  //   Future(() {
  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //     final snackBar = SnackBar(content: Text('Swipe Left to Delete Items'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   });
  // }

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
                  OrderButton(cartData: cartData)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return TextButton(
      onPressed: (widget.cartData.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false).orderNow(
                    widget.cartData.items.values.toList(),
                    widget.cartData.totalAmount);

                widget.cartData.clearCart();
                _isLoading = false;

                scaffoldMessenger.showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Ordered Successfully'),
                ));
              } catch (error) {
                scaffoldMessenger.showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Ordered Failed'),
                ));
              }
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Order Now',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }
}
