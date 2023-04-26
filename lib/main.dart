import 'package:flutter/material.dart';
import 'package:online_shop/screens/order_screen.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/product_details_screen.dart';
import './screens/cart_screen.dart';
import './screens/manage_product_screen.dart';
import './screens/edit_product_screen.dart';
import './styles/online_shop_style.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  ThemeData theme = OnlineShopStyle.theme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>(
          create: (ctx) {
            return Products();
          },
        ),
        ChangeNotifierProvider<Cart>(
          create: (ctx) {
            return Cart();
          },
        ),
        ChangeNotifierProvider<Orders>(
          create: (ctx) {
            return Orders();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme,
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          ManageProductScreen.routeName: (ctx) => const ManageProductScreen(),
          EditProductScreen.routeName: (ctx) => const EditProductScreen(),
        },
      ),
    );
  }
}
