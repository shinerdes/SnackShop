import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:snack_shop/screens/tab_bar_screen.dart';

import '../components/rounded_button.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email = "";
  late String password = "";
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
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Registration',
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
                          //Do something with the user input.
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
                          //Do something with the user input.
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText:
                                'Enter your password (at least 6 words)')),
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
                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: email, password: password);

                            FirebaseDatabase.instance
                                .ref()
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .set({"email": email});

                            setState(() {
                              showSpinner = false;
                            });

                            Navigator.pushNamedAndRemoveUntil(
                                context, TabBarScreen.id, (route) => false);
                          } on FirebaseAuthException catch (e) {
                            debugPrint("Exception : ${e.message}");
                            debugPrint("Exception : ${e.code}");
                            _showdialog(context);
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      title: 'Register',
                      colour: Colors.blueAccent,
                    ),
                  ],
                ),
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
      title: const Text('등록실패'),
      content: const Text('비밀번호는 6자리 이상'),
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
