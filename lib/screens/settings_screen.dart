import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snack_shop/screens/order_history_screen.dart';
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
              child: ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.receipt_outlined),
                      title: const Text('주문내역'),
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OrderHistoryScreen()))
                            .then((value) {});
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.logout_outlined),
                      title: const Text('로그아웃'),
                      onTap: () {
                        _showdialog(context);
                      },
                    ),
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
