import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snack_shop/theme.dart';

class SettingsMenuWidget extends StatelessWidget {
  const SettingsMenuWidget(
      {super.key,
      required this.color,
      this.isSmall = false,
      required this.icon,
      required this.taskGroup,
      required this.tapIndex});

  final MaterialColor color;
  final bool? isSmall;
  final IconData icon;
  final String taskGroup;
  final int tapIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (tapIndex == 1) {
          context.push('/settings/historylist');
        } else if (tapIndex == 2) {
          _showdialog(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color[400],
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 4,
              offset: const Offset(2, 6),
            )
          ],
          //gradient: AppColors.getDarkLinearGradient(color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: isSmall! ? Alignment.centerLeft : Alignment.center,
              child: Icon(
                icon,
                size: isSmall! ? 60 : 120,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              taskGroup,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _showdialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('로그아웃'),
      content: const Text('로그아웃 하시겠습니까?'),
      actions: [
        ElevatedButton(
            onPressed: () {
              _signOut();
              Navigator.of(context).pop();
              context.pushReplacement('/sign-in');
            },
            child: const Text('로그아웃')),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('취소')),
      ],
    ),
  );
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
