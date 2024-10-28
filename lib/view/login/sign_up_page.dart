import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:snack_shop/theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController password2TextController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  bool validated = false;

  final _auth = FirebaseAuth.instance;
  late String email = "";
  late String password = "";
  bool showSpinner = false;

  @override
  void dispose() {
    // TODO: implement dispose
    emailTextController.dispose();
    passwordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "이메일 간편가입",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.snackGray[900],
                  ),
                ),
                const Gap(20),
                const Text(
                  "이메일 계정",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: emailTextController,
                        decoration: const InputDecoration(
                          hintText: "아이디 입력",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "필수 입력 항목입니다.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                const Text(
                  "비밀번호",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(12),
                TextFormField(
                  controller: passwordTextController,
                  decoration: InputDecoration(
                    hintText: "비밀번호 입력",
                    filled: true,
                    fillColor: AppColors.newBg,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {},
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "필수 입력 항목입니다.";
                    }
                    return null;
                  },
                ),
                const Gap(12),
                TextFormField(
                  controller: password2TextController,
                  decoration: InputDecoration(
                    hintText: "비밀번호 확인",
                    filled: true,
                    fillColor: AppColors.newBg,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {},
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "필수 입력 항목입니다.";
                    }
                    if (value != passwordTextController.text.trim()) {
                      return "비밀번호가 다릅니다.";
                    }

                    return null;
                  },
                ),
                const Gap(20),
                GestureDetector(
                  onTap: () async {
                    if (email.contains("naver.com") != true) {
                      try {
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

                          // Navigator.pushNamedAndRemoveUntil(
                          //     context, TabBarScreen.id, (route) => false); 이동
                        } on FirebaseAuthException catch (e) {
                          debugPrint("Exception : ${e.message}");
                          debugPrint("Exception : ${e.code}");
                          // _showdialog(context);
                        }
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      _showdialog2(context);
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.55),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "가입하기",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> _showdialog2(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('등록실패'),
      content: const Text('네이버 계정 불가'),
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
