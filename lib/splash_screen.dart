import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation_menus/nav_bottom.dart';
import 'signin.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  late Future<bool> _session;
  late String route;

  Future<bool> _verifySession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove("userId");

    if(prefs.containsKey("userId")) {
      route = "/navBottom";
    } else {
      route = "/signin";
    }

    return true;
  }

  @override
  void initState() {
    _session = _verifySession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _session,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.hasData) {
          if(route == "/navBottom") {
            return const NavigationBottom();
          }
          else {
            return const Signin();
          }
        }
        else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("G-Store ESPRIT"),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
