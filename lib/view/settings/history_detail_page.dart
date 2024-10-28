import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:snack_shop/models/cart_model.dart';
import 'package:snack_shop/theme.dart';
import 'package:snack_shop/widget/history_detail_widget.dart';

class HistoryDetailPage extends StatefulWidget {
  late String orderTime;
  HistoryDetailPage({super.key, required this.orderTime});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_rounded,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 10.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    '${snapshot.data?[0][0]['orderName'].toString()}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.house,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 10.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: AutoSizeText(
                                    '${snapshot.data?[0][0]['orderAddress'].toString()}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary),
                                    minFontSize: 13,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 10.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    '${snapshot.data?[0][0]['phoneNumber'].toString()}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.money_rounded,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 10.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    '₩${snapshot.data?[0][0]['cost'].toString()}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(2),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.live_help,
                                      size: 40,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      child: AutoSizeText(
                                        '${snapshot.data?[0][0]['orderMemo'].toString()}',
                                        style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary),
                                        minFontSize: 15,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      Container(
                        width: 200,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1, childAspectRatio: 2.5),
                          itemCount: snapshot.data?[1].length ?? 0,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                HistoryDetailWidget(
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
