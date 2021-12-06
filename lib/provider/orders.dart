import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shopi/provider/cart.dart';

class OrderItem {
  final String id;
  final double price;
  final List<CartItems> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.price,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String authToken;
  Orders(this.authToken,this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSet() async {
    final url = 'https://shop-4aa8c-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    final res = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractData = json.decode(res.body) as Map<String, dynamic>;
    if(extractData == null){
      return;
    }
    extractData.forEach((orderID, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderID,
          price: orderData['amount'],
          dateTime: DateTime.parse(
            orderData['dateTime'],
          ),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (e) => CartItems(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItems> cartProducts, double total) async {
    final url = 'https://shop-4aa8c-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final res = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(res.body)['name'],
        price: total,
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
