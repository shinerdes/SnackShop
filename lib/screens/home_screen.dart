import 'package:flutter/material.dart';

import 'package:snack_shop/data/snack_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

// 총 주문 금액
// 주문 횟수
//

class _HomeScreen extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      bottom: true,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 20,
              ),
              Text(
                '이메일: ${_auth.currentUser!.email}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 2,
                child: const ColoredBox(color: Colors.black),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < snackDataList.length; i++)
                      Image.asset(
                          'assets/images/${snackDataList[i]['image']!}.png',
                          width: 175,
                          height: 175,
                          fit: BoxFit.cover),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 2,
                child: const ColoredBox(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
