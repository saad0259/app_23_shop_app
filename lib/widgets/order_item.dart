import 'package:flutter/material.dart';
import '../provider/orders.dart' as oi;
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final oi.OrderItem orderItem;

  OrderItem({required this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${orderItem.price}'),
            subtitle:
                Text(DateFormat('dd MM yyyy hh:mm').format(orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: (){},
            ),
          )
        ],
      ),
    );
  }
}
