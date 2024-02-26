import 'package:auto_size_text/auto_size_text.dart';
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
            width: 125, height: 125, fit: BoxFit.cover),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: AutoSizeText(
                widget.name,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                minFontSize: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
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
