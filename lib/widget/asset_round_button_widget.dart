import 'package:flutter/material.dart';

class AssetRoundButtonWidget extends StatelessWidget {
  const AssetRoundButtonWidget({
    super.key,
    this.icon = "",
    this.colour = Colors.black,
    required this.onPressed,
    this.title = "",
    this.height = 42.0,
    this.fontsize = 15.0,
    this.assetHeight = 30.0,
    this.assetwidth = 30.0,
  });

  final String icon;
  final Color colour;
  final String title;
  final Function onPressed;
  final double fontsize;
  final double height;
  final double assetHeight;
  final double assetwidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        //elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(8.0),
        child: MaterialButton(
          onPressed: () {
            onPressed();
          },
          minWidth: 200.0,
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(icon,
                  width: assetwidth, height: assetHeight, fit: BoxFit.cover),
              const SizedBox(width: 5.0),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontsize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
