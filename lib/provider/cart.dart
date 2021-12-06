import 'package:flutter/material.dart';

class CartItems {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItems({required this.id,
    required this.title,
    required this.quantity,
    required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItems> _items = {};

  Map<String, CartItems> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (-_items[productId]!.quantity > 1) {
      _items.update(productId, (value) =>
          CartItems(id: value.id,
              title: value.title,
              quantity: value.quantity - 1,
              price: value.price));
    } else {
      _items.remove(productId);
    }
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItems) {
      total += cartItems.price * cartItems.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
              (value) =>
              CartItems(
                id: value.id,
                title: value.title,
                quantity: value.quantity + 1,
                price: value.price,
              ));
    } else {
      _items.putIfAbsent(
        productId,
            () =>
            CartItems(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price,
            ),
      );
    }
    notifyListeners();
  }
}
