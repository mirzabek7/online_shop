import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/order.dart';
import '../models/cart_item.dart';

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  Future<void> getOrdersFromFirebase() async {
    final url = Uri.parse(
        'https://fir-app-22efe-default-rtdb.firebaseio.com/orders.json');
    List<Order> loadedOrders = [];
    final response = await http.get(url);
    if (jsonDecode(response.body) != null) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      try {
        data.forEach((orderId, order) {
          loadedOrders.insert(
            0,
            Order(
              id: orderId,
              totalPrice: order['price'],
              date: DateTime.parse(order['date']),
              products: (order['products'] as List<dynamic>)
                  .map(
                    (product) => CartItem(
                        id: orderId,
                        title: product['title'],
                        quantity: product['quantity'],
                        price: product['price'],
                        image: product['image']),
                  )
                  .toList(),
            ),
          );
        });
        _items = loadedOrders;
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> addOrder(List<CartItem> products, double totalPrice) async {
    final url = Uri.parse(
        'https://fir-app-22efe-default-rtdb.firebaseio.com/orders.json');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'price': totalPrice,
          'date': DateTime.now().toIso8601String(),
          'products': products
              .map((product) => {
                    'title': product.title,
                    'quantity': product.quantity,
                    'price': product.price,
                    'image': product.image,
                  })
              .toList()
        }),
      );
      _items.insert(
        0,
        Order(
            id: jsonDecode(response.body)["name"],
            totalPrice: totalPrice,
            date: DateTime.now(),
            products: products),
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
