import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/products_provider.dart';
import '/widgets/app_drawer.dart';
import '/providers/cart_provider.dart';
import '/screens/cart_screen.dart';
import '/widgets/badge.dart';
// import 'package:provider/provider.dart';
// import '/providers/products_provider.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts();
    // initState doesn't have context!!!
    // listen: false => can use
    // Future.delayed(Duration.zero).then(
    //   (_) {
    //     Provider.of<ProductsProvider>(context).fetchAndSetProducts();
    //   },
    // );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer =
    //     Provider.of<ProductsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MY SHOP'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              // print(selectedValue);
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  // productsContainer.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
                  // productsContainer.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.favorites,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
            ],
          ),
          Consumer<CartProvider>(
            builder: (context, cartData, iconButton) => Badge(
              child: iconButton!,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(
                Icons.shopping_cart,
                size: 27,
              ),
            ),
            // nó giống như kiểu đặt const cho cái widget này ý!
            // child cũng sẽ không phải build lại mỗi lần widget rebuild
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(
              showFavs: _showOnlyFavorites,
            ),
    );
  }
}
