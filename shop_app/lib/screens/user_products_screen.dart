import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '/providers/products_provider.dart';
import '/widgets/user_product_item_widget.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
    // Now, one additional note about the way we're fetching our products here,
    // we should actually add listen falls here in the refresh products method
    // to ensure that this method, which we're calling on, our provider is
    // being called. But we're not setting up a listener here because we don't
    // really want to listen to updates and products here in this method.
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(context);
    // vẫn muốn listen vì cái này phải hiện lên UI
    // nên khi có sự thay đổi sẽ cần rebuild
    // print('rebuild');
    return Scaffold(
      appBar: AppBar(
        title: const Text('YOUR PRODUCTS'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (context, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              UserProductItemWidget(
                                title: productsData.items[index].title,
                                imageUrl: productsData.items[index].imageUrl,
                                id: productsData.items[index].id,
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
