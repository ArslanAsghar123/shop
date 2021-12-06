import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/orders.dart';
import 'package:shopi/widgets/OrderItem.dart';
import 'package:shopi/widgets/drawer.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
bool _isloading = false;

  @override
  void initState() {
    _isloading = true;
     Provider.of<Orders>(context,listen:false ).fetchAndSet().then((value) => null);
     setState(() {
       _isloading = false;
     });;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),

      body: _isloading? Center(child: CircularProgressIndicator(),):ListView.builder(
        itemBuilder: (context, i) => OrderItems(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
