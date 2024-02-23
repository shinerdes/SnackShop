import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:snack_shop/components/rounded_button.dart';
import 'package:snack_shop/constants.dart';
import 'package:snack_shop/screens/tab_bar_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email = '';
  late String password = '';
  bool showSpinner = false;

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
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Login',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: SizedBox(
                          height: 100.0,
                          child: Image.asset('assets/images/snack.png',
                              width: 100, height: 100, fit: BoxFit.cover),
                        ),
                      ),
                      const Text(
                        ' Snack ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                      const Text(
                        'Shop',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your email')),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password')),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            showSpinner = true;
                          });

                          try {
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);

                            // ignore: use_build_context_synchronously
                            Navigator.pushNamedAndRemoveUntil(
                                context, TabBarScreen.id, (route) => false);
                          } on FirebaseAuthException catch (e) {
                            debugPrint("Exception : ${e.message}");
                            debugPrint("Exception : ${e.code}");
                            // ignore: use_build_context_synchronously
                            _showdialog(context);
                          }
                          //Navigator.pushNamed(context, HomeScreen.id);
                          //Navigator.pushNamed(context, HomeScreen.id);

                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      title: 'Log In',
                      colour: Colors.lightBlueAccent),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  Navigator.pop(context, false);
  return true;
}

Future<dynamic> _showdialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('실패'),
      content: const Text('로그인 실패'),
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

Future<dynamic> _showdialog2(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('실패'),
      content: const Text('정보를 입력하세요'),
      actions: [
        ElevatedButton(
            onPressed: () {
              print('cancel');
              Navigator.of(context).pop();
            },
            child: const Text('확인')),
      ],
    ),
  );
}
