import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:snack_shop/data/snack_data.dart';
import 'package:snack_shop/models/cart_model.dart';
import 'package:snack_shop/theme.dart';

class MenuDetailPage extends StatefulWidget {
  final int index;
  const MenuDetailPage({super.key, required this.index});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

final cartBag = [];

class _MenuDetailPageState extends State<MenuDetailPage> {
  final FirebaseDatabase _realtime = FirebaseDatabase.instance;

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
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Center(
                            child: Hero(
                              tag:
                                  "cartImage${snackDataList[widget.index]['image']}",
                              child: Image.asset(
                                'assets/images/${snackDataList[widget.index]['image']!}.png',
                                width: 300,
                                height: 300,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              snackDataList[widget.index]['name']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 50),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '₩${snackDataList[widget.index]['price'].toString()}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 35),
                                          ),
                                          Text(
                                            '${snackDataList[widget.index]['weight']!}',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            '${snackDataList[widget.index]['company']!}',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InputQty.int(
                                            maxVal: 99,
                                            initVal: 1,
                                            minVal: 1,
                                            steps: 1,
                                            onQtyChanged: (value) => setState(
                                                () => simpleIntInput = value),
                                            decoration: QtyDecorationProps(
                                              isBordered: false,
                                              btnColor: AppColors.primary,
                                              border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      width: 2,
                                                      color: AppColors.primary),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 10,
                                ),
                                Image.asset(
                                    'assets/images/${snackDataList[widget.index]['image']!}-detail.png',
                                    fit: BoxFit.cover),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(12),
                  GestureDetector(
                    onTap: () async {
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
                                    name: snackDataList[widget.index]['name']!,
                                    count: simpleIntInput,
                                    price: snackDataList[widget.index]['price'],
                                    image: snackDataList[widget.index]
                                        ['image']!)
                                .toJson());
                      }

                      _onBackPressed(context);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              color: AppColors.primary,
                            ),
                            Text(
                              "카트에 담기",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
