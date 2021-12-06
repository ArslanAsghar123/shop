import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/products.dart';
import 'package:shopi/screens/edit_products.dart';
import 'package:shopi/widgets/drawer.dart';
import 'package:shopi/widgets/user_product.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> _refresh(BuildContext context) async {
    final productData = Provider.of<Products>(context, listen: false);
    await productData.fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProductScreen()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refresh(context),
                    child: Consumer<Products>(
                      builder: (ctx,prodData, _) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProduct(
                                id: productData.items[i].id,
                                title: productData.items[i].title,
                                imgUrl: productData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
