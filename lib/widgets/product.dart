import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/auth.dart';
import 'package:shopi/provider/cart.dart';
import 'package:shopi/provider/product.dart';
import 'package:shopi/screens/select_product.dart';

class ProductTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authToken = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          title: Text(product.title),
          leading: IconButton(
            icon: Icon(product.isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.toggleStateFav(authToken.token!,authToken.userId!);
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('added item to cart'),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'undo',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectProduct(product.id))),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
