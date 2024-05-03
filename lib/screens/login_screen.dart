import 'dart:convert';

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:snack_shop/main.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:snack_shop/components/rounded_asset_button.dart';
import 'package:snack_shop/components/rounded_button.dart';
import 'package:snack_shop/constants.dart';
import 'package:snack_shop/screens/tab_bar_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

enum LoginPlatform {
  facebook,
  google,
  kakao,
  naver,
  apple,
  none, // logout
}

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
  void initState() {
    // TODO: implement initState
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      TabBarScreen.id, (route) => false);
                                } on FirebaseAuthException catch (e) {
                                  debugPrint("Exception : ${e.message}");
                                  debugPrint("Exception : ${e.code}");
                                  // ignore: use_build_context_synchronously
                                  _showdialog(context);
                                }

                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                print(e);
                              }
                            },
                            title: 'Log In',
                            colour: Colors.lightBlueAccent),
                        AssetRoundedButton(
                          onPressed: () async {
                            var googleUser = await signInWithGoogle();

                            if (googleUser != null) {
                              // db filter

                              var emailCheck = await FirebaseDatabase.instance
                                  .ref()
                                  .child(FirebaseAuth.instance.currentUser!.uid)
                                  .get();

                              if (emailCheck.exists == false) {
                                FirebaseDatabase.instance
                                    .ref()
                                    .child(
                                        FirebaseAuth.instance.currentUser!.uid)
                                    .set({"email": googleUser.user!.email});
                              }

                              Navigator.pushNamedAndRemoveUntil(
                                  context, TabBarScreen.id, (route) => false);
                            }
                          },
                          icon: 'assets/images/google.png',
                          title: "Google",
                          colour: Colors.blueGrey,
                        ),
                        AssetRoundedButton(
                          onPressed: () async {
                            try {
                              OAuthToken token = await UserApi.instance
                                  .loginWithKakaoAccount(); // 카카오 로그인
                              var provider =
                                  OAuthProvider('oidc.kakao'); // 제공업체 id

                              var credential = provider.credential(
                                idToken: token.idToken,
                                // 카카오 로그인에서 발급된 idToken(카카오 설정에서 OpenID Connect가 활성화 되어있어야함)
                                accessToken: token
                                    .accessToken, // 카카오 로그인에서 발급된 accessToken
                              );

                              //FirebaseAuth.instance.signInWithCredential(credential);

                              if (context.mounted) {
                                UserCredential newCredential =
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);

                                print(newCredential);

                                if (newCredential.user!.email != null) {
                                  var emailCheck = await FirebaseDatabase
                                      .instance
                                      .ref()
                                      .child(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .get();

                                  if (emailCheck.exists == false) {
                                    FirebaseDatabase.instance
                                        .ref()
                                        .child(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .set({
                                      "email": newCredential.user!.email
                                    });
                                  }

                                  Navigator.pushNamedAndRemoveUntil(context,
                                      TabBarScreen.id, (route) => false);
                                } else {}
                              }
                            } catch (error) {
                              print('카카오계정으로 로그인 실패 $error');
                            }
                          },
                          icon: 'assets/images/kakao.png',
                          title: "카카오",
                          colour: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateToMainPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyApp()));

    print('siuuuuuuu');
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

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleUser != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      return null;
    }

    // Create a new credential
  }
}
