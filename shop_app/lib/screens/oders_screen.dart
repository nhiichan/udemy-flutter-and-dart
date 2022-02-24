import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/oder_item_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // bool _isLoading = false;
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<OrdersProvider>(context, listen: false)
        .fetchAndSetOrders();
  }

  @override
  void initState() {
    super.initState();
    _ordersFuture = _obtainOrdersFuture();
    // Future.delayed(Duration.zero).then((_) async {
    // setState(() {
    //   _isLoading = true;
    // });
    // Provider.of<OrdersProvider>(context, listen: false).fetchAndSetOrders();
    // setState(() {
    //   _isLoading = false;
    // });
    // });
    // sử dụng delayed này để tạo ra được một cái return Future
  }

  @override
  Widget build(BuildContext context) {
    // print('building orders');
    // only build 1 time!!!
    // final orderData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('YOUR ORDERS'),
      ),
      drawer: const AppDrawer(),
      // The future builder widget takes a future and then automatically
      // starts listening to that.
      body: FutureBuilder(
        future: _ordersFuture,
        // Provider.of<OrdersProvider>(context, listen: false).fetchAndSetOrders(),
        // nhận vào một giá trị future
        builder: ((context, snapshot) {
          // The data snapshot here is of type async snapshot, and if you add a
          // dot after it, you see that there you can find out if you have an
          // error object or the data which you retrieved and also what the
          // current connection status and that tells you what the future is
          // currently doing.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              // error handling stuff here
              return const Text('An error occurred!');
            } else {
              return Consumer<OrdersProvider>(
                builder: ((context, orderData, child) {
                  return ListView.builder(
                    itemBuilder: ((context, index) => OrderItemWidget(
                          order: orderData.orders[index],
                        )),
                    itemCount: orderData.orders.length,
                  );
                }),
                // child: ListView.builder(
                //   itemBuilder: ((context, index) => OrderItemWidget(
                //         order: orderData.orders[index],
                //       )),
                //   itemCount: orderData.orders.length,
                // ),
              );
            }
          }
          // return _isLoading
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     : ListView.builder(
          //         itemBuilder: ((context, index) => OrderItemWidget(
          //               order: orderData.orders[index],
          //             )),
          //         itemCount: orderData.orders.length,
          //       );
        }),
      ),
    );
  }
}
