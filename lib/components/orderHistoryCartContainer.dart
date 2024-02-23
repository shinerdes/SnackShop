import 'package:flutter/material.dart';

class OrderHistoryCartContainer extends StatefulWidget {
  OrderHistoryCartContainer({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.count,
  });
  int price;
  int count;
  String name;
  String image;

  @override
  State<OrderHistoryCartContainer> createState() =>
      _OrderHistoryCartContainerState();
}

class _OrderHistoryCartContainerState extends State<OrderHistoryCartContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/${widget.image}.png',
            width: 125, height: 125, fit: BoxFit.cover),
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${widget.price.toString()}원',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${widget.count.toString()}개',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
