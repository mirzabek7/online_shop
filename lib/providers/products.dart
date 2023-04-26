// ignore_for_file: unused_field, prefer_final_fields
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import '../models/product.dart';
import '../services/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    // Product(
    //     id: "p1",
    //     title: "Samsung Galaxy S23 Ultra",
    //     description:
    //         "2023 yilning eng yaxshi flagmanlaridan biri It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like). It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
    //     price: 1500,
    //     imageUrl:
    //         "https://m-cdn.phonearena.com/images/article/145268-wide-two_1600/Samsung-Galaxy-S23-Ultra-goes-official-The-best-Samsung-phone-bar-none.webp?1675292554"),
    // Product(
    //     id: "p2",
    //     title: "Galaxy Buds 2",
    //     description:
    //         "Simsiz quloqchin It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like). It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)",
    //     price: 200,
    //     imageUrl:
    //         "https://images.unsplash.com/photo-1600374917838-1df876d745c7?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
    // Product(
    //     id: "p3",
    //     title: "Samsung TV Neo QLED 8K",
    //     description:
    //         "8K tiniqlikdagi SMART TV It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like). It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)",
    //     price: 5000,
    //     imageUrl:
    //         "https://www.hi-fi.ru/upload/resize_cache/medialibrary/697/870_700_1/rb2ndwbptx5r5na5ckijzpny4gaomvpv.jpg"),
  ];

  Future<void> getProductsFromFireBase() async {
    final url = Uri.parse(
        'https://fir-app-22efe-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);
      if (jsonDecode(response.body) != null) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        data.forEach((productId, productData) {
          loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ));
          _products = loadedProducts;
          notifyListeners();
        });
      }
    } catch (error) {
      rethrow;
    }
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favorites {
    return _products.where((product) => product.isFavorite).toList();
  }

  Product findById(String productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://fir-app-22efe-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      final name = (jsonDecode(response.body) as Map<String, dynamic>)['name'];
      final newProduct = Product(
          id: name,
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    int productIndex =
        _products.indexWhere((product) => product.id == updatedProduct.id);
    final url = Uri.parse(
        'https://fir-app-22efe-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json');
    if (productIndex >= 0) {
      try {
        await http.patch(url,
            body: jsonEncode({
              'title': updatedProduct.title,
              'description': updatedProduct.description,
              'price': updatedProduct.price,
              'imageUrl': updatedProduct.imageUrl,
            }));
        _products[productIndex] = updatedProduct;
      } catch (e) {
        rethrow;
      }
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://fir-app-22efe-default-rtdb.firebaseio.com/products/$id.json');

    try {
      var deletingProduct = _products.firstWhere((product) => product.id == id);
      int productIndex = _products.indexWhere((product) => product.id == id);
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _products.insert(productIndex, deletingProduct);
        notifyListeners();
        throw HttpException("Kechirasiz, o'chirishda xatolik yuz berdi");
      }
    } catch (e) {
      rethrow;
    }
  }
}
