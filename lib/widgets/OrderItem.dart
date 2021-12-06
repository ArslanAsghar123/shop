
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopi/provider/orders.dart';

class OrderItems extends StatelessWidget {
  final OrderItem orderItem;

  OrderItems(this.orderItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${orderItem.price}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
