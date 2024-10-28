import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:snack_shop/firebase_options.dart';
import 'package:snack_shop/router.dart';
import 'package:snack_shop/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  KakaoSdk.init(
    nativeAppKey: 'ff36bb09c6fe6689f59fbf82586a2305',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "snackshop",
      routerConfig: router,
      theme: snackDefaultTheme,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      themeAnimationStyle: AnimationStyle(
        curve: Curves.easeInCirc,
        duration: const Duration(milliseconds: 350),
      ),
    );
  }
}
