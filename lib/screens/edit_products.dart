import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/product.dart';
import 'package:shopi/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editscreen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  var _isLoading = false;
  var _editedProduct = Product(
    id: null.toString(),
    title: '',
    desc: '',
    price: 0,
    imageUrl: '',
  );
  var _initValue = {'title': '', 'desc': '', 'price': '', 'imageUrl': ''};
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    _imageUrlFocus.addListener(_addListener);
    super.initState();
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    var _productData = Provider.of<Products>(context, listen: false);
    if (_isInit) {
       final String? productId =
          ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null.toString()) {
        _editedProduct = _productData.findById(productId!);
        _initValue = {
          'title': _editedProduct.title,
          'desc': _editedProduct.desc,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }else{
        print('something Wrong');
      }
    } else {
      print('false');
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _addListener() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocus.removeListener(_addListener);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlFocus.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    var _productData = Provider.of<Products>(context, listen: false);

    var validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null.toString()) {
      await _productData.update(_editedProduct.id, _editedProduct);
    } else {
      try {
        await _productData.addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Text('Something went wrong'),
                  title: Text('Error message'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('okay'))
                  ],
                ));
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('edit Products'),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: Icon(Icons.save))
        ],
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      decoration: InputDecoration(labelText: 'title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                          title: val!,
                          desc: _editedProduct.desc,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: InputDecoration(labelText: 'price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter some number';
                        }
                        if (double.tryParse(val) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(val) <= 0) {
                          return 'Please enter a number greater than 0';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                          title: _editedProduct.title,
                          desc: _editedProduct.desc,
                          price: double.parse(val!),
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['desc'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter description';
                        }
                        if (val.length < 10) {
                          return 'Please enter some text greater than 10';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                          title: _editedProduct.title,
                          desc: val!,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          )),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter Url')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocus,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter some valid Url';
                              }
                              if (!val.startsWith('http') &&
                                  !val.startsWith('https')) {
                                return 'Please enter a valid Url';
                              }
                              if (!val.endsWith('.jpg') &&
                                  !val.endsWith('.jpeg') &&
                                  !val.endsWith('.png') &&
                                  !val.endsWith('.80')) {
                                return 'Please enter a valid iMAGE   Url';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFav: _editedProduct.isFav,
                                title: _editedProduct.title,
                                desc: _editedProduct.desc,
                                price: _editedProduct.price,
                                imageUrl: val!,
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
