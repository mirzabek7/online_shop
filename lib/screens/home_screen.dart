import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../widgets/product_grid.dart';
import '../widgets/custom_cart.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';

enum filtersOption {
  All,
  Favorites,
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  static const routeName = "/";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Samsung Shop"),
        centerTitle: true,
        actions: [
          PopupMenuButton(onSelected: (filtersOption filter) {
            setState(() {
              if (filter == filtersOption.All) {
                _showOnlyFavorites = false;
              } else {
                _showOnlyFavorites = true;
              }
            });
          }, itemBuilder: (ctx) {
            return const [
              PopupMenuItem(
                value: filtersOption.All,
                child: Text("Barchasi"),
              ),
              PopupMenuItem(
                value: filtersOption.Favorites,
                child: Text("Sevimli"),
              ),
            ];
          }),
          Consumer<Cart>(
            builder: (ctx, cart, child) {
              return CustomCart(
                number: cart.itemCount().toString(),
                child: child!,
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductGrid(_showOnlyFavorites),
    );
  }
}
