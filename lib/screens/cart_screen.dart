import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:snack_shop/components/cartSnackContainer.dart';
import 'package:snack_shop/components/rounded_button.dart';

import 'package:snack_shop/models/cart_model.dart';
import 'package:snack_shop/screens/checkout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final categoriesNumbersResponse = FirebaseDatabase.instance
      // ignore: deprecated_member_use
      .reference()
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('cart');

  Cart aa = const Cart(image: 'bananakig', name: '바나나킥', price: 1600, count: 1);

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
      body: FutureBuilder(
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
            // print(countArray);
            // print(nameArray);
            // print(priceArray);
            // print(imageArray);
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
                              crossAxisCount: 1, childAspectRatio: 1.7),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: CartSnackContainer(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 200,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (snapshot
                                                        .data![index].count !=
                                                    1) {
                                                  dataUpdate(
                                                      count: snapshot
                                                              .data![index]
                                                              .count -
                                                          1,
                                                      name: snapshot
                                                          .data![index].image);
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                              size: 35,
                                            )),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            '${countArray[index]}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 35),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (snapshot
                                                        .data![index].count !=
                                                    99) {
                                                  dataUpdate(
                                                      count: snapshot
                                                              .data![index]
                                                              .count +
                                                          1,
                                                      name: snapshot
                                                          .data![index].image);
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.black,
                                              size: 35,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          child: const Text(
                                            '삭제',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              child: const ColoredBox(color: Colors.black),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  RoundedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                    cost: sum(snapshot),
                                  ))).then((value) {
                        setState(() {});
                      });
                    },
                    title: '총 ${sum(snapshot)}원 결제하기',
                    colour: Colors.black,
                    fontSize: 21.0,
                    height: 62.0,
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
                    child: Center(
                        child: Text(
                      '담겨있는 과자가 없습니다',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.0),
                    )),
                  ),
                ],
              ),
            );
          }
        },
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






/*
 Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const SizedBox(height: 20.0),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (snapshot
                                                        .data![index].count !=
                                                    1) {
                                                  dataUpdate(
                                                      count: snapshot
                                                              .data![index]
                                                              .count -
                                                          1,
                                                      name: snapshot
                                                          .data![index].image);
                                                }
                                              });

                                              print('minus');
                                            },
                                            child: const Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 25,
                                            )),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: Colors.white),
                                          child: Text(
                                            '${countArray[index]}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 25),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (snapshot
                                                        .data![index].count !=
                                                    99) {
                                                  dataUpdate(
                                                      count: snapshot
                                                              .data![index]
                                                              .count +
                                                          1,
                                                      name: snapshot
                                                          .data![index].image);
                                                }
                                              });
                                              print('plus');
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 25,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          child: const Text(
                                            '삭제',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
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
*/