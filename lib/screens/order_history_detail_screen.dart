import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:snack_shop/components/orderHistoryCartContainer.dart';
import 'package:snack_shop/models/cart_model.dart';
import 'package:snack_shop/models/order_model.dart';

// ignore: must_be_immutable
class OrderHistoryDetailScreen extends StatefulWidget {
  late String orderTime;

  OrderHistoryDetailScreen({super.key, required this.orderTime});

  @override
  State<OrderHistoryDetailScreen> createState() =>
      _OrderHistoryDetailScreenState();
}

class _OrderHistoryDetailScreenState extends State<OrderHistoryDetailScreen> {
  late Future<Order> siu;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Cart> buyList = [];
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
          body: FutureBuilder(
              future: Future.wait(
                  [readChild(widget.orderTime), readList(widget.orderTime)]),
              builder: (context, snapshot) {
                if (snapshot.hasData == true) {
                  buyList = snapshot.data![1].cast<Cart>();
                }
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                        child: const ColoredBox(color: Colors.black),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${snapshot.data?[0][0]['orderName'].toString()}',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w900),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  '${snapshot.data?[0][0]['orderAddress'].toString()}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                  minFontSize: 13,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Text(
                                '${snapshot.data?[0][0]['phoneNumber'].toString()}',
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w700)),
                            Text(
                              '금액 : ₩${snapshot.data?[0][0]['cost'].toString()}',
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w700),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '주문시 요청사항',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.grey),
                                ),
                                AutoSizeText(
                                  '${snapshot.data?[0][0]['orderMemo'].toString()}',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                  minFontSize: 15,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                        child: const ColoredBox(color: Colors.black),
                      ),
                      Expanded(
                        flex: 2,
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1, childAspectRatio: 3),
                          itemCount: snapshot.data?[1].length ?? 0,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                OrderHistoryCartContainer(
                                    name: buyList[index].name,
                                    price: buyList[index].price,
                                    image: buyList[index].image,
                                    count: buyList[index].count),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Container orderHistoryUserInfoContainer(BuildContext context,
      AsyncSnapshot<List<List<dynamic>>> snapshot, int index, String txt) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
      color: Colors.amberAccent,
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: Text(
        txt,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  Navigator.pop(context, false);
  return true;
}

Future<List<dynamic>> readChild(String order) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('order')
      .child(order)
      .get();

  List data2 = [];
  if (snapshot.exists) {
    Map<dynamic, dynamic> toMap = snapshot.value as Map<dynamic, dynamic>;
    toMap.remove('buy');
    data2.add(toMap);
    return data2;
  } else {
    return List.empty();
  }
}

Future<List<dynamic>> readList(String order) async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('order')
      .child(order)
      .child('buy')
      .get();
  if (snapshot.exists) {
    Map<dynamic, dynamic> toMap = snapshot.value as Map<dynamic, dynamic>;
    List<Cart> data = toMap.values.map((e) => Cart.fromJson(e)).toList();
    return data;
  } else {
    return List.empty();
  }
}
