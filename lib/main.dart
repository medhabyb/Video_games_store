import 'package:flutter/material.dart';

import 'navigation_menus/nav_bottom.dart';
import 'navigation_menus/nav_tab.dart';
import 'product_details.dart';
import 'reset_password.dart';
import 'signin.dart';
import 'signup.dart';
import 'splash_screen.dart';
import 'update_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G-Store ESPRIT',
      routes: {
        "/": (BuildContext context) {
          return const SpalshScreen();
        },
        "/signin": (BuildContext context) {
          return const Signin();
        },
        "/resetPwd": (BuildContext context) {
          return const ResetPassword();
        },
        "/signup": (BuildContext context) {
          return const Signup();
        },
        "/home/updateUser": (BuildContext context) {
          return const UpdateUser();
        },
        "/navBottom": (BuildContext context) {
          return const NavigationBottom();
        },
        "/home/navTab": (BuildContext context) {
          return const NavigationTab();
        },
        "/home/productDetails": (BuildContext context) {
          return const ProductDetails();
        }
      },
    );
  }
}