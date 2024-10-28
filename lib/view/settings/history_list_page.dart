import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:snack_shop/widget/history_list_widget.dart';

class HistoryListPage extends StatefulWidget {
  const HistoryListPage({super.key});

  @override
  State<HistoryListPage> createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  @override
  void initState() {
    super.initState();
  }

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
      child: FutureBuilder(
          future: readChild(),
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: const Text(''),
              ),
              body: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) =>
                            HistoryListWidget(
                          date: toDate(snapshot.data![index]),
                          orderTime: snapshot.data![index],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    ));
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  Navigator.pop(context, false);
  return true;
}

Future<List<String>> readChild() async {
  List<String> resultList = [];

  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('order')
      .get();

  if (snapshot.exists) {
    Map<dynamic, dynamic> toMap = snapshot.value as Map<dynamic, dynamic>;
    List onlyKey = toMap.keys.toList();

    for (int i = 0; i < snapshot.children.length; i++) {
      resultList.add(onlyKey[i]);
    }
  }

  return resultList;
}

toDate(String date) {
  List<String> pt1 = date.split("-");

  List<String> pt2 = pt1[0].split(":");

  List<String> pt3 = pt1[1].split(":");

  String outDate = "20${pt2[0]}년 ${pt2[1]}월 ${pt2[2]}일 ${pt3[0]}시 ${pt3[1]}분";

  return outDate;
}
