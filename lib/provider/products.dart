import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopi/provider/product.dart';
import 'package:http/http.dart' as http;
import 'package:shopi/widgets/exception.dart';

class Products with ChangeNotifier {
  late String authToken;
  String userId;

  Products(this.authToken, this.userId, this._items);

// late String _userId;
//
// void updates(String token,String userId){
//   authToken = token;
//   _userId = userId;
// }

  List<Product> _items = [];

  List<Product> get items {
    return _items;
  }

  Future<void> update(String id, Product product) async {
    final probIndex = _items.indexWhere((element) => element.id == id);
    if (probIndex >= 0) {
      final url =
          'https://shop-4aa8c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'desc': product.desc,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      _items[probIndex] = product;
      notifyListeners();
    } else {
      print('sss');
    }
  }

  List<Product> get showFavs {
    return _items.where((element) => element.isFav).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id, orElse: null);
  }

  Future<void> delete(String id) async {
    final url =
        'https://shop-4aa8c-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProIndex = _items.indexWhere((val) => val.id == id);
    var existingPro = _items[existingProIndex];
    _items.removeAt(existingProIndex);
    notifyListeners();
    final res = await http.delete(Uri.parse(url));

    if (res.statusCode >= 400) {
      _items.insert(existingProIndex, existingPro);
      notifyListeners();
      throw ExceptionClass('Could not del this product');
    }
    existingPro = Null as Product;
  }

  Future<void> fetchProducts([bool filter = false]) async {
    final filterString = filter==true ? 'orderBy="creatorId"&equalTo="$userId" ':'';
    final url =
        'https://shop-4aa8c-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final res = await http.get(Uri.parse(url));
      final extractData = json.decode(res.body) as Map<String, dynamic>;

      final url2 =
          'https://shop-4aa8c-default-rtdb.firebaseio.com/usersFavs/$userId.json?auth=$authToken';
      final favres = await http.get(Uri.parse(url2));
      final favData = json.decode(favres.body);
      final List<Product> loadedData = [];
      extractData.forEach((probId, probData) {
        loadedData.add(Product(
            id: probId,
            title: probData['title'],
            desc: probData['desc'],
            price: probData['price'],
            isFav: favData[probId] ,
            imageUrl: probData['imageUrl']));
      });
      _items = loadedData;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addProduct(Product editedProduct) async {
    final url =
        'https://shop-4aa8c-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': editedProduct.title,
          'desc': editedProduct.desc,
          'imageUrl': editedProduct.imageUrl,
          'price': editedProduct.price,
          'creatorId': userId
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: editedProduct.title,
          desc: editedProduct.desc,
          price: editedProduct.price,
          imageUrl: editedProduct.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }
}
