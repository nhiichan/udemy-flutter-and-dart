import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/products_provider.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
    required this.showFavs,
  }) : super(key: key);

  final bool showFavs;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    // final products = productsData.items;
    final products = showFavs ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // amount of column
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10, // spacing between columns
        mainAxisSpacing: 10, // spacing between rows
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        // print(products[index].title);
        return ChangeNotifierProvider.value(
          // create: (BuildContext context) => products[index],
          // thông thường ở đây sẽ phải return 1 cái instance của cái provider
          // nhưng mà ở đây cái provider lại là Product()
          // mà mình lại không muốn tạo một cái instance mới của Product
          // => trả luôn về cái products[index]!
          key: Key("item$index"),
          // add key để tránh dính error!
          value: products[index],
          // ignore: prefer_const_constructors
          child: ProductItem(
              // id: products[index].id,
              // title: products[index].title,
              // imageUrl: products[index].imageUrl,
              ),
        );
      },
    );
  }
}
