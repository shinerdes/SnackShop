import 'package:flutter/material.dart';
import 'package:snack_shop/screens/cart_screen.dart';
import 'package:snack_shop/screens/home_screen.dart';
import 'package:snack_shop/screens/menu_screen.dart';
import 'package:snack_shop/screens/settings_screen.dart';

class TabBarScreen extends StatelessWidget {
  static const String id = 'tap_bar_screen';
  TabBarScreen({super.key});

  final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const MenuScreen(),
    const CartScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: const SizedBox(
            height: 80,
            child: TabBar(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              tabs: <Widget>[
                Tab(
                    icon: Icon(
                  Icons.home_outlined,
                  size: 35,
                )),
                Tab(
                    icon: Icon(
                  Icons.search,
                  size: 35,
                )),
                Tab(
                    icon: Icon(
                  Icons.shopping_bag_outlined,
                  size: 35,
                )),
                Tab(
                    icon: Icon(
                  Icons.movie_outlined,
                  size: 35,
                )),
              ],
              // indicatorColor: Colors.transparent, // indicator 없애기
              // unselectedLabelColor: Colors.grey, // 선택되지 않은 tab 색
              // labelColor: Colors.black, // 선택된 tab의 색
            ),
          ),
          body: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: _widgetOptions,
            ),
          ),
        ),
      ),
    );
  }
}
