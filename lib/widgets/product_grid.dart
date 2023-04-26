import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../models/product.dart';

class ProductGrid extends StatefulWidget {
  final bool showFavorites;
  const ProductGrid(this.showFavorites, {super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late Future _productsFuture;
  Future getProductsFuture() {
    return Provider.of<Products>(context, listen: false)
        .getProductsFromFireBase();
  }

  @override
  void initState() {
    // TODO: implement initState
    _productsFuture = getProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _productsFuture,
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapShot.error == null) {
            return Consumer<Products>(
              builder: (c, productsData, child) {
                var products = widget.showFavorites
                    ? productsData.favorites
                    : productsData.products;
                return products.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 3 / 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20),
                        itemCount: products.length,
                        itemBuilder: (ctx, i) {
                          return ChangeNotifierProvider<Product>.value(
                            value: products[i],
                            child: ProductItem(),
                          );
                        },
                      )
                    : const Center(
                        child: Text("Mahsulotlar mavjud emas"),
                      );
              },
            );
          } else {
            return const Center(
              child: Text("Xatolik yuz berdi"),
            );
          }
        });
  }
}
