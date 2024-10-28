import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'package:snack_shop/theme.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "로그인",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.snackGray[900],
              ),
            ),
            const Gap(32),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                      hintText: "이메일 입력",
                    ),
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: passwordTextController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "비밀번호 입력",
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),
            GestureDetector(
              onTap: () async {
                if (emailTextController.text.isEmpty ||
                    passwordTextController.text.isEmpty) {
                  return;
                }

                try {
                  await _auth.signInWithEmailAndPassword(
                      email: emailTextController.text.trim(),
                      password: passwordTextController.text.trim());

                  context.pushReplacement('/home');

                  // ignore: use_build_context_synchronously
                } on FirebaseAuthException catch (e) {
                  debugPrint("Exception : ${e.message}");
                  debugPrint("Exception : ${e.code}");
                  // ignore: use_build_context_synchronously
                  _showdialog(context);
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "이메일로 로그인하기",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "아직 계정이 없나요?",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.snackGray[900],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    context.push("/sign-up");
                  },
                  child: const Text(
                    "회원가입",
                  ),
                ),
              ],
            ),
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.newBg,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Gap(8),
                const Text("소셜 계정으로 간편 로그인"),
                const Gap(8),
                Container(
                  width: 48,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.newBg,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    //google sign in

                    var googleUser = await signInWithGoogle();

                    if (googleUser != null) {
                      var emailCheck = await FirebaseDatabase.instance
                          .ref()
                          .child(FirebaseAuth.instance.currentUser!.uid)
                          .get();

                      if (emailCheck.exists == false) {
                        FirebaseDatabase.instance
                            .ref()
                            .child(FirebaseAuth.instance.currentUser!.uid)
                            .set({"email": googleUser.user!.email});
                      }
                      // ignore: use_build_context_synchronously
                      context.pushReplacement('/home');
                    }
                  },
                  child: const CircleAvatar(
                    radius: 30.0,
                    backgroundColor: AppColors.primary,
                    child: CircleAvatar(
                      radius: 28.0,
                      backgroundColor: Colors.white,
                      foregroundImage: AssetImage('assets/images/google.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    try {
                      OAuthToken token = await UserApi.instance
                          .loginWithKakaoAccount(); // 카카오 로그인
                      var provider = OAuthProvider('oidc.kakao'); // 제공업체 id

                      var credential = provider.credential(
                        idToken: token.idToken,
                        // 카카오 로그인에서 발급된 idToken(카카오 설정에서 OpenID Connect가 활성화 되어있어야함)
                        accessToken:
                            token.accessToken, // 카카오 로그인에서 발급된 accessToken
                      );

                      //FirebaseAuth.instance.signInWithCredential(credential);

                      if (context.mounted) {
                        UserCredential newCredential = await FirebaseAuth
                            .instance
                            .signInWithCredential(credential);

                        print(newCredential);

                        if (newCredential.user!.email != null) {
                          var emailCheck = await FirebaseDatabase.instance
                              .ref()
                              .child(FirebaseAuth.instance.currentUser!.uid)
                              .get();

                          if (emailCheck.exists == false) {
                            FirebaseDatabase.instance
                                .ref()
                                .child(FirebaseAuth.instance.currentUser!.uid)
                                .set({"email": newCredential.user!.email});
                          }
                          // ignore: use_build_context_synchronously
                          context.pushReplacement('/home');
                        } else {}
                      }
                    } catch (error) {
                      print('카카오계정으로 로그인 실패 $error');
                    }
                  },
                  child: const CircleAvatar(
                    radius: 30.0,
                    backgroundColor: AppColors.primary,
                    child: CircleAvatar(
                      radius: 28.0,
                      backgroundColor: Colors.white,
                      foregroundImage: AssetImage('assets/images/kakao.png'),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(24),
          ],
        ),
      ),
    );
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
