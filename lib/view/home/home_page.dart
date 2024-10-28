import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:intl/intl.dart';

import 'package:snack_shop/theme.dart';
import 'package:snack_shop/widget/asset_round_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final numberFormatter = NumberFormat('###,###,###,###');
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
      // backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 624,
              child: Column(
                children: [
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.emoji_people_outlined,
                        size: 40.0,
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        '${_auth.currentUser!.email}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  CarouselSlider(
                    items: [
                      for (int i = 0; i < imagesName.length; i++)
                        Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/${imagesName[i]}.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                      height: 280.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 600),
                      viewportFraction: 0.8,
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Gap(12),
                  AssetRoundButtonWidget(
                    title: " 농심몰",
                    onPressed: () {
                      launchUrl(Uri.parse('https://nongshimmall.com/'));
                    },
                    icon: 'assets/images/nongsim.png',
                    colour: AppColors.primary,
                    assetHeight: 30.0,
                    assetwidth: 30.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
