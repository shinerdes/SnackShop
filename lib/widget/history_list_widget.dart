import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snack_shop/theme.dart';

class HistoryListWidget extends StatelessWidget {
  final String date;
  final String orderTime;
  const HistoryListWidget({
    super.key,
    required this.date,
    required this.orderTime,
  });

  @override
  Widget build(BuildContext context) {
    List<String> parts = date.split(" ");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          context.push("/settings/historylist/historydetail/$orderTime");
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            decoration: BoxDecoration(
                color: AppColors.secondary,
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 14.0, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.timer_rounded,
                                size: 50,
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Text(
                                parts[0],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' ${parts[1]} ${parts[2]} ',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${parts[3]} ${parts[4]}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
