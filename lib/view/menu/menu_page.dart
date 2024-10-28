import 'package:flutter/material.dart';
import 'package:snack_shop/data/snack_data.dart';
import 'package:snack_shop/widget/menu_name_widget.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Snack',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 50.0,
                      child: Image.asset('assets/images/snack.png',
                          width: 50, height: 50, fit: BoxFit.fill),
                    ),
                  ),
                  const Text(
                    'Shop',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 2,
                child: const ColoredBox(color: Colors.black),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: snackDataList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8),
                  itemBuilder: (context, index) {
                    return MenuNameWidget(
                      name: snackDataList[index]['name']!,
                      price:
                          int.parse(snackDataList[index]['price'].toString()),
                      image: snackDataList[index]['image']!,
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
