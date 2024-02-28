import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:snack_shop/firebase_options.dart';

import 'package:snack_shop/screens/login_screen.dart';
import 'package:snack_shop/screens/order_history_screen.dart';
import 'package:snack_shop/screens/registration_screen.dart';
import 'package:snack_shop/screens/tab_bar_screen.dart';
import 'package:snack_shop/screens/welcome_screen.dart';

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
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        TabBarScreen.id: (context) => TabBarScreen(),
      },
    );
  }
}
