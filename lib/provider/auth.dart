import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shopi/widgets/exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expireData;
bool get isAuth{
  return token != null;
}
 String? get token{
  if(_expireData != null && _expireData!.isAfter(DateTime.now()) && _token != null){
    return _token;
  }
  return null;
}
String? get userId{
  return _userId;
}
  Future<void> _validate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAK_K2IWlu7meLB8bk3ZbWdmLL-ZtfTeFs';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final response = json.decode(res.body);
      if(response['error'] != null){

        throw ExceptionClass(response['error']['message']);
      }
      _token = response['idToken'];
      _userId = response['localId'];
      _expireData = DateTime.now().add(Duration(seconds: int.parse(response['expiresIn'])));
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _validate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _validate(email, password, 'signInWithPassword');
  }
}
