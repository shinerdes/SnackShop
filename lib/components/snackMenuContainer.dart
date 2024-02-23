import 'package:flutter/material.dart';
import 'package:snack_shop/screens/snack_detail_screen.dart';

class SnackMenuContainer extends StatelessWidget {
  const SnackMenuContainer({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.index,
  });

  final String name;
  final int price;
  final String image;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SnackDetailScreen(
                      index: index,
                    ))).then((value) {});
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Hero(
            tag: "cartImage$image",
            child: Image.asset('assets/images/$image.png',
                width: 125, height: 125, fit: BoxFit.fill),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            child: Text('$price원', style: const TextStyle(fontSize: 15)),
          ),
        ]),
      ),
    );
  }
}
