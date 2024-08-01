import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepup/app.dart';
import 'package:stepup/data/api/api.dart';
import 'package:stepup/data/models/account_model.dart';
import 'package:stepup/data/providers/account_vm.dart';
import 'package:stepup/screens/signIn_Up/login.dart';

import 'package:stepup/utilities/const.dart';
import 'package:stepup/global/functions.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  _xacNhanEmail(User? user) async {
    dialogDangKy(context);

    // post account lên api
    Account newAcc = Account(
        Email: _emailController.text,
        Password: _passwordController.text,
        UserName: _usernameController.text);
    ApiService apiService = ApiService();
    await apiService.postAccount(newAcc).then(
      (response) {
        if (response == 200) {
          Timer.periodic(
            const Duration(seconds: 6),
            (timer) async {
              FirebaseAuth.instance.signOut();
              FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);
              final signIn = FirebaseAuth.instance.currentUser;

              if (signIn?.emailVerified == true) {
                logger.d('Đăng ký thành công và xác nhận email');
                timer.cancel();
                await Provider.of<AccountVMS>(context, listen: false)
                    .setCurrentAcc(_emailController.text);
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              } else if (!mounted) {
                logger.d('Huỷ xác nhận đăng ký');
                timer.cancel();
                FirebaseAuth.instance.signOut();
              }
            },
          );
        }
      },
    );
  }

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPWController = TextEditingController();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPWController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text(
              'Đăng ký',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image(
                    image: AssetImage(imagePath),
                    alignment: Alignment.center,
                    fit: BoxFit.fitWidth,
                    opacity: AlwaysStoppedAnimation(.4),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textField(
                              _emailController,
                              "Email",
                              "",
                              const Icon(Icons.email),
                              false,
                            ),
                            textField(
                              _usernameController,
                              "Tên người dùng",
                              "",
                              const Icon(Icons.person),
                              false,
                            ),
                            pwTextField(
                              _passwordController,
                              _confirmPWController,
                              "Mật khẩu mới",
                              "",
                              const Icon(Icons.password),
                              true,
                            ),
                            pwTextField(
                              _confirmPWController,
                              _passwordController,
                              "Xác nhận mật khẩu",
                              "",
                              const Icon(Icons.check),
                              true,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: FilledButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await taoTaiKhoanTrongFirebase(
                                        _emailController,
                                        _passwordController,
                                      );
                                    }
                                  },
                                  child: const Text("Đăng ký"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> errorDialogDangKy(String? message) async {
    /// Getting the current context of the widget in the widget tree
    final context = _formKey.currentContext;

    if (context != null && context.mounted) {
      /// statements after async gap without warning
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lỗi đăng ký'),
          content: Text(message ?? 'Không biết lỗi'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> taoTaiKhoanTrongFirebase(
    TextEditingController tecEmail,
    TextEditingController tecPassword,
  ) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: tecEmail.text, password: tecPassword.text)
          .then((auth) async {
        if (auth.user != null) {
          guiEmailXacNhan(auth.user);

          _xacNhanEmail(FirebaseAuth.instance.currentUser!);
        }
      });
    } on FirebaseAuthException catch (e) {
      logger.e('Failed with error code: ${e.code}');
      logger.e(e.message);
      if (e.code == 'weak-password') {
        errorDialogDangKy('Mật khẩu nên đặt từ 6 ký tự trở lên');
      } else if (e.code == 'email-already-in-use') {
        errorDialogDangKy('Tài khoản đã tồn tại');
      } else if (e.code == 'network-request-failed') {
        errorDialogDangKy('Không có kết nối Wi-Fi hoặc dữ liệu di động');
      } else {
        errorDialogDangKy(e.message);
      }
    }
  }

  // Future<void> linkAnonInFirebase(
  //     TextEditingController tecEmail, TextEditingController tecPassword) async {
  //   final credential = EmailAuthProvider.credential(
  //       email: tecEmail.text, password: tecPassword.text);

  //   try {
  //     await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     fetchData(e.message);
  //   }
  // }

  dialogDangKy(BuildContext context) {
    Dialog loadingDialog = Dialog(
        child: Container(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Vui lòng kiểm tra email',
              style: TextStyle(fontSize: 18),
            ),
          ),
          CircularProgressIndicator(),
        ],
      ),
    ));
    showDialog(
        context: context, builder: (BuildContext context) => loadingDialog);
  }
}
