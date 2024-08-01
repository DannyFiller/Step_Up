// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepup/data/providers/account_vm.dart';
import 'package:stepup/data/providers/favorite_vm.dart';
import 'package:stepup/data/providers/product_vm.dart';
import 'package:stepup/main.dart';
import 'package:stepup/screens/mainPage/Info.dart';
import 'package:stepup/screens/mainPage/order_history.dart';
import 'package:stepup/screens/mainPage/guide_page.dart';
import 'package:stepup/utilities/const.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AccountVMS>(
        builder: (BuildContext context, value, Widget? child) {
          return Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: Colors.black26),
                      shape: BoxShape.circle),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: NetworkImage(value.currentAcc!.Image!),
                    onBackgroundImageError: (exception, stackTrace) {
                      AssetImage("${urlimg}account.png");
                    },
                  ),
                ),
                // Container(
                //   clipBehavior: Clip.antiAlias,
                //   height: 150,
                //   width: 150,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //   ),
                //   child: Image.network(
                //     fit: BoxFit.contain,
                //     value.currentAcc!.Image!,
                //     errorBuilder: (context, error, stackTrace) {
                //       return Image.asset("${urlimg}account.png");
                //     },
                //   ),
                // ),
                //Text
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    value.currentAcc!.UserName!,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      listSettings(
                        Icons.account_circle_outlined,
                        'Thông tin cá nhân',
                        InfoPage(),
                        null,
                      ),
                      listSettings(
                        Icons.history,
                        'Lịch sử đơn hàng',
                        OrderHistory(),
                        null,
                      ),
                      listSettings(
                        Icons.help_outline,
                        'Hướng dẫn sử dụng',
                        GuidePage(),
                        null,
                      ),
                      Divider(),
                      listSettings(
                        Icons.logout,
                        'Đăng xuất',
                        StartScreen(),
                        Colors.red,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget listSettings(IconData icon, String label, Widget page, Color? color) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(
        icon,
        color: color,
      ),
      trailing: !label.contains('Đăng xuất') ? Icon(Icons.arrow_forward) : null,
      title: Text(
        label,
        style: TextStyle(color: color),
      ),
      onTap: () {
        if (label.contains('Đăng xuất')) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cảnh báo'),
              content: Text('Bạn chắc chắn muốn đăng xuất?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Huỷ')),
                TextButton(
                  onPressed: () {
                    _signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartScreen(),
                      ),
                      ModalRoute.withName('/start'),
                    );
                  },
                  child: const Text('Xác nhận'),
                )
              ],
            ),
          );
          Provider.of<ProductVMS>(context, listen: false).clear();
          Provider.of<FavoriteVm>(context, listen: false).clear();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return page;
              },
            ),
          );
        }
      },
    );
  }
}
