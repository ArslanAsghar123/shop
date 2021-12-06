import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/products.dart';
import 'package:shopi/widgets/product.dart';

class GridWidget extends StatelessWidget {
  final bool showfav;
  GridWidget(this.showfav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showfav?productData.showFavs:productData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value:products[i],
        child: ProductTile(

        ),
      ),
    );
  }
}
