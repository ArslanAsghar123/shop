import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopi/provider/cart.dart';
import 'package:shopi/provider/products.dart';
import 'package:shopi/screens/cart.dart';
import 'package:shopi/widgets/Products_Grid.dart';
import 'package:shopi/widgets/badge.dart';
import 'package:shopi/widgets/drawer.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductOverview extends StatefulWidget {
  const ProductOverview({Key? key}) : super(key: key);

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool _isFav = false;
  bool _isInit = true;
  bool _isLoading = false;
  Future<void> _refresh(BuildContext context) async {
    final productData =  Provider.of<Products>(context,listen : false);
    await productData.fetchProducts();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
   final probData = Provider.of<Products>(context, listen: false);
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      probData.fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      }
      );
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectValue) {
              setState(() {
                if (selectValue == FilterOption.Favorite) {
                  _isFav = true;
                } else {
                  _isFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert_rounded),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorite'),
                value: FilterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: _isLoading? Center(child: CircularProgressIndicator(),) :GridWidget(_isFav),
        ),
      ),
    );
  }
}
