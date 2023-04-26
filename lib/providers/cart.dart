import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int itemCount() {
    return _items.length;
  }

  void addToCart(
    String productId,
    String title,
    double price,
    String image,
  ) {
    if (_items.containsKey(productId)) {
      // second time
      _items.update(
        productId,
        (currentProduct) => CartItem(
            id: currentProduct.id,
            title: currentProduct.title,
            quantity: currentProduct.quantity + 1,
            price: currentProduct.price,
            image: currentProduct.image),
      );
    } else {
      // yangi product qo'shilmoqda
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: UniqueKey().toString(),
            title: title,
            quantity: 1,
            price: price,
            image: image),
      );
    }
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((key, cartItem) {
      total = total + (cartItem.price * cartItem.quantity);
    });
    return total;
  }

  void removeSingleItem(String productId, {bool isCart = false}) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (currentProduct) => CartItem(
              id: currentProduct.id,
              title: currentProduct.title,
              quantity: currentProduct.quantity - 1,
              price: currentProduct.price,
              image: currentProduct.image));
    } else if (isCart) {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
