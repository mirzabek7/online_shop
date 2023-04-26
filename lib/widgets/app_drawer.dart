import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/order_screen.dart';
import '../screens/manage_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text("Salom Do'stim"),
          ),
          ListTile(
            leading: Icon(Icons.shop_sharp),
            title: const Text(
              "Do'kon",
              style: TextStyle(fontSize: 19),
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: const Text(
              "Buyurtmalar",
              style: TextStyle(fontSize: 19),
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(
              "Mahsulotlarni boshqarish",
              style: TextStyle(fontSize: 19),
            ),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ManageProductScreen.routeName),
          ),
        ],
      ),
    );
  }
}
