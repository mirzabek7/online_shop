import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_shop/models/order.dart';
import 'package:online_shop/providers/orders.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/orders_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const routeName = "/orders";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  Future _getOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).getOrdersFromFirebase();
  }

  // bool isLoading = false;
  @override
  void initState() {
    _ordersFuture = _getOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Buyurtmalar"),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: _ordersFuture,
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapShot.error == null) {
                return Consumer<Orders>(
                  builder: (context, orders, child) {
                    return orders.items.isEmpty
                        ? const Center(
                            child: Text("Buyurtmalar mavjud emas"),
                          )
                        : ListView.builder(
                            itemBuilder: (ctx, index) {
                              final order = orders.items[index];
                              return OrdersItem(order: order);
                            },
                            itemCount: orders.items.length,
                          );
                  },
                );
              } else {
                return const Center(
                  child: Text("Xatolik yuz berdi"),
                );
              }
            })
        // : isLoading
        // ? const

        );
  }
}
