import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imageUrl;
  bool isFav;

  Product(
      {required this.id,
      required this.title,
      required this.desc,
      required this.price,
      required this.imageUrl,
      this.isFav = false});

  void _oldToggle(bool newVal) {
    isFav = newVal;
    notifyListeners();
  }

  Future<void> toggleStateFav(String token,String userID) async {
    final oldFav = isFav;

    isFav = !isFav;
    notifyListeners();
    final url = 'https://shop-4aa8c-default-rtdb.firebaseio.com/usersFavs/$userID/$id.json?auth=$token';
    try {
      final res = await http.put(Uri.parse(url),
          body: json.encode(
            isFav,
          ));
      if (res.statusCode >= 400) {
        _oldToggle(oldFav);
        notifyListeners();
      }
    } catch (e) {
      _oldToggle(oldFav);
      notifyListeners();
    }
  }
}
