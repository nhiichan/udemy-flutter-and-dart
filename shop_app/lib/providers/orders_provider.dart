import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '/models/order_item.dart';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];
  final String? authToken;
  final String? userId;

  OrdersProvider({
    this.authToken,
    this.userId,
    required List<OrderItem> inputOrders,
  }) : _orders = inputOrders;

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-udemi-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    // để tránh sau đó bị lệch thời gian trong quá trình xử lý
    final response = await http.post(
      url,
      body: json.encode(
        {
          'dateTime': timestamp.toIso8601String(),
          'amount': total,
          'products': cartProducts
              .map(
                (e) => {
                  'id': e.id,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price,
                },
              )
              .toList(),
          // map cartItem into map
        },
      ),
    );
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ));
    // insert at the begin - 0 to the end.
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-udemi-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    // print(json.decode(response.body));
    // {-MwApgDxhFftBHjqipkI: {amount: 359.92, dateTime: 2022-02-18T14:58:18.189586,
    // products: [{id: 2022-02-18 14:58:13.076129, price: 49.99, quantity: 6, title: A Pan},
    // {id: 2022-02-18 14:58:14.770799, price: 29.99, quantity: 2, title: Red Shirt!!!!}]},
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return;
      // đề phòng không có order nào
    }
    // print(extractedData);
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'],
              ),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    // show newest order
    notifyListeners();
  }
}
