import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:snack_shop/models/cart_model.dart';
import 'package:snack_shop/theme.dart';
import 'package:snack_shop/widget/cart_snack_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final categoriesNumbersResponse = FirebaseDatabase.instance
      // ignore: deprecated_member_use
      .reference()
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('cart');

  List<int> countArray = [];
  List<String> imageArray = [];
  List<String> nameArray = [];
  List<int> priceArray = [];

  @override
  void initState() {
    // TODO: implement initState
    readChild();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      readChild();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: readChild(),
          builder: (context, snapshot) {
            countArray = [];
            imageArray = [];
            nameArray = [];
            priceArray = [];

            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              for (int i = 0; i < snapshot.data!.length; i++) {
                countArray.add(snapshot.data![i].count);
                nameArray.add(snapshot.data![i].name);
                priceArray.add(snapshot.data![i].price);
                imageArray.add(snapshot.data![i].image);
              }
              return Container(
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 2,
                      child: const ColoredBox(color: Colors.black),
                    ),
                    Expanded(
                      child: GridView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, childAspectRatio: 1.8),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 9,
                                      child: CartSnackWidget(
                                        name: nameArray[index],
                                        price: priceArray[index],
                                        image: imageArray[index],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    InputQty.int(
                                      maxVal: 99,
                                      initVal: countArray[index],
                                      minVal: 1,
                                      steps: 1,
                                      onQtyChanged: (count) => setState(
                                        () {
                                          dataUpdate(
                                              count: count,
                                              name:
                                                  snapshot.data![index].image);
                                        },
                                      ),
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
                                    Container(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            child: const Icon(
                                              Icons.not_interested,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                dataDelete(
                                                    name: snapshot
                                                        .data![index].image);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.bg,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const Gap(16),
                    GestureDetector(
                      onTap: () async {
                        context
                            .push("/cart/checkout/${sum(snapshot)}")
                            .then((a) => setState(() {}));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '총 ${sum(snapshot)}원 결제하기',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Image.asset('assets/images/snack.png',
                            width: 50, height: 50, fit: BoxFit.fill),
                        const Text(
                          'Shop',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 2,
                      child: const ColoredBox(color: Colors.black),
                    ),
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.no_food, size: 100),
                          SizedBox(height: 5.0),
                          Text(
                            '담겨있는 과자가 없습니다',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

sum(AsyncSnapshot<List<Cart>> snapshot) {
  int total = 0;

  for (int i = 0; i < snapshot.data!.length; i++) {
    total = total + (snapshot.data![i].price * snapshot.data![i].count);
  }

  return total;
}

Future<dynamic> _deleteDialog(BuildContext context, String name) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('삭제'),
      content: const Text('정말 삭제하시겠습니까?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            dataDelete(name: name);

            Navigator.of(context).pop();
          },
          child: const Text('확인'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('캔슬'),
        ),
      ],
    ),
  );
}

Future<void> dataDelete({required String name}) async {
  await FirebaseDatabase.instance
      .ref()
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('cart')
      .child(name)
      .remove();
}

Future<void> dataUpdate({required String name, required int count}) async {
  await FirebaseDatabase.instance
      .ref()
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('cart')
      .child(name)
      .update({'count': count}).then((value) => print('update 완료'));
}

Future<List<Cart>> readChild() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('cart')
      .get();

  if (snapshot.exists) {
    Map<dynamic, dynamic> toMap = snapshot.value as Map<dynamic, dynamic>;

    List<Cart> data = toMap.values.map((e) => Cart.fromJson(e)).toList();

  
    return data;
  } else {
    return List.empty();
  }
}
