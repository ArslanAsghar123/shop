import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/auth.dart';
import 'package:shopi/screens/product_overview_screen.dart';
import 'package:shopi/widgets/exception.dart';

enum AuthMode { Signup, login }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(215, 117, 255, 0.5),
                      Color.fromRGBO(255, 188, 117, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1])),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black,
                                offset: Offset(0, 2))
                          ]),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1, child: AuthCard())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passController = TextEditingController();


   void showErrDialog(String msg){
     showDialog(context: context, builder: (ctx) => AlertDialog(
       title: Text('An err occurred'),
       content: Text(msg) ,
       actions: [
         FlatButton(onPressed: (){
           Navigator.of(ctx).pop();
         }, child: Text('OK'))
       ],
     ));
   }
  Future<void> _submitData() async {
    final auth = Provider.of<Auth>(context, listen: false);

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        await auth.signIn(_authData['email']!, _authData['password']!);
      } else {
        await auth.signUp(_authData['email']!, _authData['password']!);
      }
    } on ExceptionClass catch (err) {
      var errMsg = 'Auth failed';
      if (err.toString().contains('EMAIL_EXISTS')) {
        errMsg = 'this email is already in use';
      } else if (err.toString().contains('INVALID_EMAIL')) {
        errMsg = 'this email is Invalid';
      } else if (err.toString().contains('WEAK_PASSWORD')) {
        errMsg = 'Weak password error';
      } else if (err.toString().contains('EMAIL_NOT_FOUND')) {
        errMsg = 'this email is not found';
      } else if (err.toString().contains('INVALID_PASSWORD')) {
        errMsg = 'Invalid password';
      }
      showErrDialog(errMsg);
    } catch (err) {
      final errMsg = 'Could not authenticate you at the moment';
      showErrDialog(errMsg);

    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val!.isEmpty || !val.contains('@')) {
                      return ' Invalid email';
                    }
                  },
                  onSaved: (val) {
                    _authData['email'] = val!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passController,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 5) {
                      return 'Short Password < 5';
                    }
                  },
                  onSaved: (val) {
                    _authData['password'] = val!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (val) {
                            if (val != _passController.text) {
                              return 'Password do not match ';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    onPressed: _submitData,
                    child:
                        Text(_authMode == AuthMode.login ? 'Login' : 'SignUp'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  ),
                FlatButton(
                  onPressed: _switchMode,
                  child: Text(
                      '${_authMode == AuthMode.login ? 'SignUp' : 'Login'} Instead'),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
