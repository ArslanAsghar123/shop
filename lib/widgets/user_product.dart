import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/product.dart';
import 'package:shopi/provider/products.dart';
import 'package:shopi/screens/edit_products.dart';

class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  UserProduct({required this.id, required this.title, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final productData = Provider.of<Products>(context, listen: false);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: id.toString());
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () async {
                  try {
                    await productData.delete(id);
                  } catch (e) {
                    scaffold.showSnackBar(SnackBar(content: Text('this item cannot be delete',textAlign: TextAlign.left,)));
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
