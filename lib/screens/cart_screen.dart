import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_list_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sizning Savatchangiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Umumiy: ",
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        "\$ ${cart.totalPrice}",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) {
                  final cartItem = cart.items.values.toList()[index];
                  return CartListItem(
                      productId: cart.items.keys.toList()[index],
                      imageUrl: cartItem.image,
                      price: cartItem.price,
                      quantity: cartItem.quantity,
                      title: cartItem.title);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var scaffoldmessage = ScaffoldMessenger.of(context);
    return TextButton(
      onPressed: (widget.cart.items.isEmpty || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalPrice);
                setState(() {
                  isLoading = false;
                });
                widget.cart.clearCart();
              } catch (e) {
                setState(() {
                  isLoading = false;
                });
                scaffoldmessage.showSnackBar(
                  const SnackBar(
                    content: Text("Buyurmada xatolik yuz berdi"),
                  ),
                );
              }
            },
      child: isLoading
          ? const CircularProgressIndicator()
          : const Text("BUYURTMA QILISH"),
    );
  }
}
