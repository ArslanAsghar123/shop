import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String productId;

  const CartItem({
    Key? key,
    required this.productId,
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartRemove = Provider.of<Cart>(context);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cartRemove.removeItem(productId);
      },
      secondaryBackground: Container(
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete,color: Colors.white,size: 40,),
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Are you sure'),
                  content: Text('Do you want to remove the item from cart'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('No'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes'),
                    ),
                  ],
                ));
      },
      background: Container(
        color: Colors.red,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                "\$$price",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ),
            title: Text(title),
            subtitle: Text('total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
