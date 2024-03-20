import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snack_shop/screens/order_history_screen.dart';
import 'package:snack_shop/screens/welcome_screen.dart';

class SettingsMenuContainer extends StatelessWidget {
  final MaterialColor color;
  final bool? isSmall;
  final IconData icon;
  final String taskGroup;
  final int tapIndex;

  const SettingsMenuContainer(
      {super.key,
      required this.color,
      this.isSmall = false,
      required this.icon,
      required this.taskGroup,
      required this.tapIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (tapIndex == 1) {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrderHistoryScreen()))
              .then((value) {});
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
          gradient: AppColors.getDarkLinearGradient(color),
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
              Navigator.pushNamedAndRemoveUntil(
                  context, WelcomeScreen.id, (route) => false);
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

class AppColors {
  static bool isDarkMode = false;

  static Color get primaryColor => Colors.pink[400]!;
  static MaterialColor get primarySwatch => Colors.pink;
  static Color get accentColor => isDarkMode ? primaryColor : Colors.grey[600]!;
  static Color get bgColor => isDarkMode ? Colors.black : Colors.grey[50]!;

  static ThemeData get getTheme => ThemeData(
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: bgColor,
          iconTheme: IconThemeData(
            color: Colors.grey[500],
          ),
          elevation: 0,
          foregroundColor: Colors.grey[600],
        ),
        textTheme: TextTheme(
          displayMedium: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w800,
            fontSize: 28,
          ),
          displaySmall: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          labelMedium: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        scaffoldBackgroundColor: bgColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
      );

  static LinearGradient getLinearGradient(MaterialColor color) {
    return LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        color[300]!,
        color[200]!,
        color[100]!,
      ],
      stops: const [
        0.4,
        0.7,
        0.9,
      ],
    );
  }

  static LinearGradient getDarkLinearGradient(MaterialColor color) {
    return LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        color[400]!,
        color[300]!,
        color[200]!,
      ],
      stops: const [
        0.4,
        0.6,
        1,
      ],
    );
  }

  static LinearGradient getDarkLinearGradient2(Color getColor) {
    return LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        getColor.withOpacity(0.9),
        getColor.withOpacity(0.6),
        getColor.withOpacity(0.3),
      ],
      stops: const [
        0.4,
        0.6,
        1,
      ],
    );
  }

  static LinearGradient getDarkLinearGradient3(Color getColor) {
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        getColor.withOpacity(0.9),
        getColor.withOpacity(0.6),
        getColor.withOpacity(0.3),
      ],
      stops: const [
        0.3,
        0.6,
        1,
      ],
    );
  }

  static LinearGradient getDarkLinearGradient4(Color getColor) {
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        getColor.withOpacity(0.9),
        getColor.withOpacity(0.6),
        Colors.white,
      ],
      stops: const [
        0.3,
        0.6,
        1,
      ],
    );
  }
}
