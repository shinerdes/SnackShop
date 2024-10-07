import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:snack_shop/components/checkoutCartContainer.dart';
import 'package:snack_shop/components/rounded_icon_button.dart';
import 'package:snack_shop/models/cart_model.dart';
import 'package:flutter/services.dart';

class CheckoutScreen extends StatefulWidget {
  final int cost;
  const CheckoutScreen({super.key, required this.cost});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _memoTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _addressTextController = TextEditingController();

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

        // 구매자 정보 - 이메일
        // 배송지
        // 구매 품목 내용
        // 결제 옵션 (x)
        // 결제 버튼
        // 결제 시 cart 부분 제거 + 항목들 order로 이동
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: FutureBuilder(
              future: readChild(),
              builder: (context, snapshot) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 90,
                                      child: Text(
                                        '이름',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          160,
                                      child: TextField(
                                        controller: _nameTextController,
                                        decoration: const InputDecoration(
                                          hintText: '이름',
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 90,
                                      child: Text(
                                        '주소',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 20), //
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          160,
                                      child: TextField(
                                        keyboardType: TextInputType.multiline,
                                        minLines: 2,
                                        maxLines: 2,
                                        controller: _addressTextController,
                                        decoration: const InputDecoration(
                                          hintText: '배송받으실 주소 ',
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 90,
                                      child: Text(
                                        '휴대폰 번호',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          160,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: _phoneTextController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]'))
                                        ],
                                        decoration: const InputDecoration(
                                          hintText: '휴대폰 번호',
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Text(
                                        '배송시 요청사항',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: TextField(
                                        controller: _memoTextController,
                                        decoration: const InputDecoration(
                                          hintText: '배송시 요청사항',
                                          border: OutlineInputBorder(),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: GridView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1, childAspectRatio: 3),
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: CheckoutCartContainer(
                                    name: snapshot.data![index].name,
                                    price: snapshot.data![index].price,
                                    image: snapshot.data![index].image,
                                    count: snapshot.data![index].count,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 15.0),
                        alignment: Alignment.centerRight,
                        height: 40,
                        child: Text(
                          '합계: ₩${widget.cost}',
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                      IconRoundedButton(
                        onPressed: () async {
                          if (_nameTextController.text != '' &&
                              _addressTextController.text != '' &&
                              _phoneTextController.text != '' &&
                              _memoTextController.text != '') {
                            DateTime dt = DateTime.now();

                            String formatDate =
                                DateFormat('yy:MM:dd-HH:mm:ss').format(dt);

                            await FirebaseDatabase.instance
                                .ref()
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .child('order')
                                .child(formatDate)
                                .set({
                              "orderName": _nameTextController.text,
                              "orderAddress": _addressTextController.text,
                              "phoneNumber": _phoneTextController.text,
                              "orderMemo": _memoTextController.text,
                              "cost": widget.cost,
                            });

                            for (int aa = 0; aa < snapshot.data!.length; aa++) {
                              await FirebaseDatabase.instance
                                  .ref()
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .child('order')
                                  .child(formatDate)
                                  .child('buy')
                                  .child(snapshot.data![aa].image)
                                  .set(Cart(
                                          name: snapshot.data![aa].name,
                                          count: snapshot.data![aa].count,
                                          price: snapshot.data![aa].price,
                                          image: snapshot.data![aa].image)
                                      .toJson());
                            }

                            await FirebaseDatabase.instance
                                .ref()
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .child('cart')
                                .remove();

                            _onBackPressed(context);
                          } else {
                            _showdialog(context);
                          }
                        },
                        icon: Icons.payment,
                        title: ' 주문하기',
                        colour: Colors.black,
                        fontsize: 21.0,
                        height: 62.0,
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  Navigator.pop(context, false);
  return true;
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

extension StringExtensions on String {
  String removeWhitespace() {
    return replaceAll(' ', ';');
  }
}

Future<dynamic> _showdialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('구매실패'),
      content: const Text('정보를 확인해주세요'),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('확인')),
      ],
    ),
  );
}
