import 'package:flutter/material.dart';

class CustomCart extends StatelessWidget {
  final Widget child;
  final String number;
  const CustomCart({super.key, required this.child, required this.number});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            alignment: Alignment.center,
            width: 12,
            height: 12,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Text(
              number,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}
