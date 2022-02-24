import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/custom_route.dart';
import 'providers/auth.dart';
import 'screens/auth_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/oders_screen.dart';
import 'providers/orders_provider.dart';
import 'screens/cart_screen.dart';
import 'providers/cart_provider.dart';
import 'screens/product_detail_screen.dart';
// import 'screens/products_overview_screen.dart';
import 'providers/products_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        // authToken is inside Auth Provider
        // So how do we get the token out of auth into here?
        // You could find complex solutions where you actually
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (context) => ProductsProvider(inputItems: []),
          update:
              (BuildContext context, auth, ProductsProvider? previousProducts) {
            // value is from Auth Provider
            // Giờ cái Products Provider sẽ phụ thuộc cái Auth
            // previous = previous state
            return ProductsProvider(
              authToken: auth.token,
              userId: auth.userId,
              inputItems:
                  previousProducts == null ? [] : previousProducts.items,
            );
          },
          // (BuildContext context, value, ProductsProvider? previous) {  }
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),

        ChangeNotifierProxyProvider<Auth, OrdersProvider>(
          create: (context) => OrdersProvider(inputOrders: []),
          update: (BuildContext context, auth, OrdersProvider? previousOrders) {
            return OrdersProvider(
              authToken: auth.token,
              userId: auth.userId,
              inputOrders: previousOrders == null ? [] : previousOrders.orders,
            );
          },
          // (BuildContext context, value, ProductsProvider? previous) {  }
        ),
      ],
      // ChangeNotifierProvider.value(
      // wrap with the Provider!
      // create: (BuildContext context) => ProductsProvider(),
      //   value: ProductsProvider(),
      child: Consumer<Auth>(
        // rebuild whenever auth changing
        builder: ((context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Shop',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.indigo,
              ).copyWith(
                secondary: Colors.amber,
                error: Colors.red,
              ),
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              ),
            ),
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    // snapshot sẽ nhận dữ liệu sau klhi future chạy xong!
                    builder: (context, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: ((context) => const CartScreen()),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
              // AuthScreen.routeName: (context) => const AuthScreen(),
            },
          );
        }),
      ),
    );
  }
}
