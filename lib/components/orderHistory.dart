import 'package:flutter/material.dart';
import 'package:snack_shop/components/settingsMenuContainer.dart';
import 'package:snack_shop/screens/order_history_detail_screen.dart';

class orderHistory extends StatelessWidget {
  final String date;
  final String orderTime;

  const orderHistory({super.key, required this.date, required this.orderTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderHistoryDetailScreen(
                        orderTime: orderTime,
                      ))).then((value) {});
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            decoration: BoxDecoration(
              //color: Colors.pink, // added
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 1, 1, 1).withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 4,
                  offset: const Offset(2, 6),
                )
              ],
              gradient: AppColors.getDarkLinearGradient2(Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.timer_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
