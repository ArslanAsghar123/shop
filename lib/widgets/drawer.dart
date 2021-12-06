import 'package:flutter/material.dart';
import 'package:shopi/screens/orders.dart';
import 'package:shopi/screens/product_overview_screen.dart';
import 'package:shopi/screens/user_products.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('shop'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductOverview()));

            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.shop),
            title: Text('orders'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserProductsScreen()));

            },
          ),
        ],
      ),
    );
  }
}
