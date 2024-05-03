import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:snack_shop/components/rounded_asset_button.dart';

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

/*
List<Map<String, dynamic>> snackDataList = [
  {
    'name': '새우깡',
    'price': 1600,
    'weight': '76g',
    'company': '농심',
    'image': 'saeukkang'
  },
  {
    'name': '고구마깡',
    'price': 1600,
    'weight': '76g',
    'company': '농심',
    'image': 'gogumakkang'
  },
  {
    'name': '꿀꽈배기',
    'price': 2200,
    'weight': '76g',
    'company': '농심',
    'image': 'kkulkkwabaegi'
  },
  {
    'name': '바나나킥',
    'price': 1600,
    'weight': '76g',
    'company': '농심',
    'image': 'bananakig'
  },
  {
    'name': '옥수수깡',
    'price': 1600,
    'weight': '76g',
    'company': '농심',
    'image': 'ogsusukkang'
  },
  {
    'name': '인디안밥',
    'price': 1600,
    'weight': '76g',
    'company': '농심',
    'image': 'indianbab'
  },
  {
    'name': '쫄병스낵 바베큐맛',
    'price': 1600,
    'weight': '55g',
    'company': '농심',
    'image': 'Jjolboksnack_BBQ_Flavor'
  },
  {
    'name': '감자깡',
    'price': 1600,
    'weight': '55g',
    'company': '농심',
    'image': 'gam-ja-ggang'
  },
];

*/

class _HomeScreen extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List imagesName = [
    'saeukkang',
    'gogumakkang',
    'kkulkkwabaegi',
    'bananakig',
    'ogsusukkang',
    'indianbab',
    'Jjolboksnack_BBQ_Flavor',
    'gam-ja-ggang'
  ];

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
              Row(
                children: [
                  const Icon(
                    Icons.emoji_people_outlined,
                    size: 40.0,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    '${_auth.currentUser!.email}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 20,
              ),
              CarouselSlider(
                items: [
                  for (int i = 0; i < imagesName.length; i++)
                    Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/${imagesName[i]}.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
                options: CarouselOptions(
                  height: 300.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 600),
                  viewportFraction: 0.8,
                ),
              ),
              AssetRoundedButton(
                title: " 농심몰",
                onPressed: () {},
                icon: 'assets/images/nongsim.png',
                colour: Colors.black,
                assetHeight: 30.0,
                assetwidth: 30.0,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
