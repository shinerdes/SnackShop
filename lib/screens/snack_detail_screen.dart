import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:snack_shop/data/snack_data.dart';
import 'package:snack_shop/models/cart_model.dart';

class SnackDetailScreen extends StatefulWidget {
  final int index;

  const SnackDetailScreen({super.key, required this.index});

  //index

  @override
  State<SnackDetailScreen> createState() => _SnackDetailScreenState();
}

final cartBag = [];

class _SnackDetailScreenState extends State<SnackDetailScreen> {
  final FirebaseDatabase _realtime = FirebaseDatabase.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String currentUserEmail = _auth.currentUser?.email ?? 'no email';

  int simpleIntInput = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          _onBackPressed(context);
        },
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Hero(
                      tag: "cartImage${snackDataList[widget.index]['image']}",
                      child: Image.asset(
                        'assets/images/${snackDataList[widget.index]['image']!}.png',
                        width: 300,
                        height: 300,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 2,
                    child: const ColoredBox(color: Colors.black),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snackDataList[widget.index]['name']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 50),
                          ),
                          Text(
                            '가격: ${snackDataList[widget.index]['price'].toString()}원',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 35),
                          ),
                          Text(
                            '중량: ${snackDataList[widget.index]['weight']!}',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 30),
                          ),
                          Text(
                            '제조사: ${snackDataList[widget.index]['company']!}',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 30),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              QuantityInput(
                                readOnly: true,
                                buttonColor: Colors.blue,
                                value: simpleIntInput,
                                onChanged: (value) => setState(
                                  () => simpleIntInput = int.parse(
                                    value.replaceAll(',', ''),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.blueAccent.shade100,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 75,
                      child: TextButton(
                          onPressed: () async {
                            final exist = await FirebaseDatabase.instance
                                .ref()
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .child('cart')
                                .child(snackDataList[widget.index]['image']!)
                                .get();

                            if (exist.exists == true) {
                              dataUpdate(
                                  name: snackDataList[widget.index]['image']!,
                                  count: simpleIntInput);
                            } else {
                              await _realtime
                                  .ref()
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .child('cart')
                                  .child(snackDataList[widget.index]['image']!)
                                  .set(Cart(
                                          name: snackDataList[widget.index]
                                              ['name']!,
                                          count: simpleIntInput,
                                          price: snackDataList[widget.index]
                                              ['price'],
                                          image: snackDataList[widget.index]
                                              ['image']!)
                                      .toJson());
                            }

                            _onBackPressed(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_checkout_outlined,
                                size: 30,
                              ),
                              Text(
                                '카트에 담기',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  Navigator.pop(context, false);
  return true;
}

Future<bool> existCheckData({required String name}) async {
  final exist = await FirebaseDatabase.instance
      .ref()
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('cart')
      .child(name)
      .get();

  if (exist.exists == true) {
  } else {}

  return exist.exists;
}

Future<void> dataUpdate({required String name, required int count}) async {
  final before = await FirebaseDatabase.instance
      .ref()
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('cart')
      .child(name)
      .child('count')
      .get();

  var beforeCount = int.parse(before.value.toString());

  await FirebaseDatabase.instance
      .ref()
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('cart')
      .child(name)
      .update({"count": beforeCount + count});
}
