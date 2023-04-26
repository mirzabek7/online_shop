import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';

class OrdersItem extends StatefulWidget {
  final Order order;
  const OrdersItem({
    super.key,
    required this.order,
  });

  @override
  State<OrdersItem> createState() => _OrdersItemState();
}

class _OrdersItemState extends State<OrdersItem> {
  bool expendedItem = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.order.totalPrice}"),
            subtitle: Text(
              DateFormat("dd/MM/yyyy hh:mm").format(widget.order.date),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  expendedItem = !expendedItem;
                });
              },
              icon: Icon(expendedItem ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (expendedItem)
            Container(
              height: min(widget.order.products.length * 20 + 50, 100),
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return ListTile(
                    title: Text("${widget.order.products[i].title}"),
                    trailing: Text(
                      "${widget.order.products[i].quantity}x${widget.order.products[i].price}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                },
                itemCount: widget.order.products.length,
              ),
            ),
        ],
      ),
    );
  }
}
