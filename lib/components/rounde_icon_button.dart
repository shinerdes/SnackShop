import 'package:flutter/material.dart';

class IconRoundedButton extends StatelessWidget {
  const IconRoundedButton(
      {super.key,
      this.icon = Icons.abc,
      this.colour = Colors.black,
      required this.onPressed,
      this.title = ""});

  final IconData icon;
  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            onPressed();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/google.png',
                  width: 30, height: 30, fit: BoxFit.cover),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
