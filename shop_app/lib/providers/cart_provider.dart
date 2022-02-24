import 'package:flutter/material.dart';
import '/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    // check if we already have this item in the CartProvider => increase the quantity
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
          productId,
          (existingCartProviderItem) => CartItem(
                id: existingCartProviderItem.id,
                title: existingCartProviderItem.title,
                quantity: existingCartProviderItem.quantity + 1,
                price: existingCartProviderItem.price,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartProviderItem) => CartItem(
          id: existingCartProviderItem.id,
          title: existingCartProviderItem.title,
          quantity: existingCartProviderItem.quantity - 1,
          price: existingCartProviderItem.price,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
