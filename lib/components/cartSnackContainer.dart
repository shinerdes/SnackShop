import 'package:flutter/material.dart';

class CartSnackContainer extends StatefulWidget {
  CartSnackContainer({
    super.key,
    required this.name,
    required this.price,
    required this.image,
  });
  int price;
  String name;
  String image;

  @override
  State<CartSnackContainer> createState() => _CartSnackContainerState();
}

class _CartSnackContainerState extends State<CartSnackContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(children: [
        Image.asset('assets/images/${widget.image}.png',
            width: 125, height: 150, fit: BoxFit.cover),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                '${widget.price.toString()}원',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
