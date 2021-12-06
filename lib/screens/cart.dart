import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/cart.dart';
import 'package:shopi/provider/orders.dart';
import 'package:shopi/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'data',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount}',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.teal,
                ),
               OrderButton(cart: cart),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => CartItem(
                      id: cart.items.values.toList()[i].id,
                      productId: cart.items.keys.toList()[i],
                      title: cart.items.values.toList()[i].title,
                      quantity: cart.items.values.toList()[i].quantity,
                      price: cart.items.values.toList()[i].price)))
        ],
      ),
    );
  }
}
class OrderButton extends StatefulWidget {
  final Cart cart;

  const OrderButton({Key? key, required this.cart}) : super(key: key);
  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context);
    bool _isLoading = false;

    return  FlatButton(
        onPressed:(widget.cart.totalAmount <= 0 || _isLoading)? null: () async{
          setState(() {
            _isLoading = true;
          });
         await order.addOrder(
              widget.cart.items.values.toList(), widget.cart.totalAmount);
          setState(() {
            _isLoading = false;
          });
          widget.cart.clearCart();
        },
        child: _isLoading ==  true? Center(child: CircularProgressIndicator()):Text('Order now'));
  }
}

