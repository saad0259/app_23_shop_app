import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../provider/orders.dart' as oi;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final oi.OrderItem orderItem;

  OrderItem({required this.orderItem});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.orderItem.price.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                .format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: min(widget.orderItem.product.length * 20.0 + 60, 120),
              child: ListView.builder(
                  itemCount: widget.orderItem.product.length,
                  itemBuilder: (ctx, i) =>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.orderItem.product[i].title, style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,

                          ),),
                          Text('${widget.orderItem.product[i]
                              .quantity}x  \$${widget.orderItem.product[i]
                              .price.toStringAsFixed(2)} ', style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),),
                        ],
                      )),
            )
        ],
      ),
    );
  }
}
