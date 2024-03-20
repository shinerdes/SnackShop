import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:snack_shop/components/settingsMenuContainer.dart';

import 'package:snack_shop/screens/welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreen createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
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
            const SizedBox(height: 10),
            SingleChildScrollView(child: Expanded(child: buildGrid(context))),
            // Expanded(
            //   child: ListView(
            //     children: <Widget>[
            //       Card(
            //         child: ListTile(
            //           leading: const Icon(Icons.receipt_outlined),
            //           title: const Text('주문내역'),
            //           onTap: () {
            //             Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) =>
            //                             const OrderHistoryScreen()))
            //                 .then((value) {});
            //           },
            //         ),
            //       ),
            //       Card(
            //         child: ListTile(
            //           leading: const Icon(Icons.logout_outlined),
            //           title: const Text('로그아웃'),
            //           onTap: () {
            //             _showdialog(context);
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _showdialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('로그아웃'),
      content: const Text('로그아웃 하시겠습니까?'),
      actions: [
        ElevatedButton(
            onPressed: () {
              _signOut();
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                  context, WelcomeScreen.id, (route) => false);
            },
            child: const Text('로그아웃')),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('취소')),
      ],
    ),
  );
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

StaggeredGrid buildGrid(BuildContext context) {
  return StaggeredGrid.count(
    crossAxisCount: 2,
    mainAxisSpacing: 15,
    crossAxisSpacing: 15,
    children: const [
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1.3,
        child: SettingsMenuContainer(
          color: Colors.red,
          icon: Icons.receipt_long_outlined,
          taskGroup: "주문내역",
          tapIndex: 1,
        ),
      ),
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1.3,
        child: SettingsMenuContainer(
          color: Colors.brown,
          icon: Icons.logout_outlined,
          taskGroup: "로그아웃",
          tapIndex: 2,
        ),
      ),
    ],
  );
}
