import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth.dart';
import '/providers/cart_provider.dart';
import '../../models/product.dart';
import '/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;

  // const ProductItem({
  //   Key? key,
  //   required this.id,
  //   required this.title,
  //   required this.imageUrl,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    // because when we use Provider.of, u can see that this product is final
    // => when state change, we will have to rebuild all the widget
    // but when we change listen to false and use consumer, only the widget
    // which really change when our product change will be rebuild!
    // interested in single Product, not a list of Product!
    final cart = Provider.of<CartProvider>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: (() {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => ProductDetailScreen(
            //       title: title,
            //     ),
            //   ),
            // );
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          }),
          child: Hero(
            //  so hero is a widget that only makes sense
            // if you're switching between different screens.
            tag: product.id,
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black45,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            // builder: (BuildContext context, value, Widget? child) {  },
            builder: (BuildContext context, product, Widget? child) =>
                IconButton(
              onPressed: () => product.toggleFavoriteStatus(
                  authData.userId!, authData.token!),
              // label: child, => this child won't change => doesn't rebuild!
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 20,
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
            // child: Text('Never Changes!'),
          ), // to the left
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              // if there is a snack bar already, this will be hidden before
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Added item to cart!',
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(
                    seconds: 2,
                  ),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
              // to the nearest app layout (scaffold)
              // here is in product_overview_screen.
            },
            icon: const Icon(
              Icons.shopping_cart,
              size: 20,
            ),
            color: Theme.of(context).colorScheme.secondary, // to the right
          ),
        ), // add a bar or a part at the bottom
      ),
    );
  }
}
