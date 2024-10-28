import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:snack_shop/models/cart_model.dart';
import 'package:snack_shop/theme.dart';
import 'package:snack_shop/widget/checkout_cart_snack_widget.dart';

class CheckoutPage extends StatefulWidget {
  final int cost;

  const CheckoutPage({super.key, required this.cost});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _memoTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _addressTextController = TextEditingController();

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
                              Form(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _nameTextController,
                                      decoration: const InputDecoration(
                                        hintText: "이름 입력",
                                      ),
                                    ),
                                    const Gap(10),
                                    TextFormField(
                                      controller: _phoneTextController,
                                      decoration: const InputDecoration(
                                        hintText: "휴대폰 번호 입력",
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[0-9]'))
                                      ],
                                    ),
                                    const Gap(10),
                                    TextFormField(
                                      controller: _addressTextController,
                                      decoration: const InputDecoration(
                                        hintText: "주소 입력",
                                      ),
                                    ),
                                    const Gap(20),
                                    TextFormField(
                                      controller: _memoTextController,
                                      decoration: const InputDecoration(
                                        hintText: "메모 입력",
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
                                  child: CheckoutCartSnackWidget(
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
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 15.0),
                        alignment: Alignment.centerRight,
                        height: 40,
                        child: Text(
                          '합계: ₩${widget.cost}',
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Gap(8),
                      GestureDetector(
                        onTap: () async {
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
                                  Icons.payment,
                                  color: AppColors.primary,
                                ),
                                Text(
                                  " 주문하기",
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
                );
              }),
        ),
      ),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  //Navigator.pop(context, true);
  Navigator.pop(context, false);
  //Navigator.of(context).pop(false);

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
