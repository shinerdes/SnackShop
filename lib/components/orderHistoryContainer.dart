import 'package:flutter/material.dart';

import 'package:snack_shop/components/settingsMenuContainer.dart';
import 'package:snack_shop/screens/order_history_detail_screen.dart';

class OrderHistoryContainer extends StatelessWidget {
  final String date;
  final String orderTime;
  // final int cost;

  const OrderHistoryContainer(
      {super.key, required this.date, required this.orderTime});

  @override
  Widget build(BuildContext context) {
    List<String> parts = date.split(" ");
    print(parts);

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
            height: 100,
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
                      Column(
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
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Text(
                                parts[0],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                '${parts[1]} ${parts[2]}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                '${parts[3]} ${parts[4]}',
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
