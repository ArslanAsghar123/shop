import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/products.dart';

class SelectProduct extends StatelessWidget {
  final String id;

  SelectProduct(this.id);

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Products>(context).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(loadedProduct.imageUrl,fit: BoxFit.cover,),
            ),
            SizedBox(height: 10,),
            Text('\$${loadedProduct.price}',style: TextStyle(fontSize: 25),),
            Container(child: Text('${loadedProduct.desc}',softWrap: true,),)
          ],
        ),
      ),
    );
  }
}
