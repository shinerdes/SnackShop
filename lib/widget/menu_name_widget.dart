import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snack_shop/theme.dart';

class MenuNameWidget extends StatelessWidget {
  const MenuNameWidget({
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
      onTap: () {
        // MenuDetailPage
        context.push("/menu/menudetail/$index");
      },

      /*
height: 50,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
      */
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: AppColors.secondary,
            border: Border.all(
              color: AppColors.primary,
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
            child: AutoSizeText(
              name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              minFontSize: 10,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
