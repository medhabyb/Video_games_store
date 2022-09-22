import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workshop_gamix2122/basket/basket.dart';
import 'package:workshop_gamix2122/home/home.dart';
import 'package:workshop_gamix2122/my_games/my_games.dart';

class NavigationTab extends StatelessWidget {
  const NavigationTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: const Text("G-Store ESPRIT"),
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.edit),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Modifier profil"),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/home/updateUser");
                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.vertical_align_bottom),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Navigation du bas"),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/navBottom");
                },
              ),
              ListTile(
                title: Row(
                  children: const [
                    Icon(Icons.power_settings_new),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Se déconnecter"),
                  ],
                ),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove("userId");
                  Navigator.pushReplacementNamed(context, "/signin");
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("G-Store ESPRIT"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: "Store",
              ),
              Tab(
                icon: Icon(Icons.article),
                text: "Bibliothèque",
              ),
              Tab(
                icon: Icon(Icons.shopping_basket_rounded),
                text: "Panier",
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Home(), MyGames(), Basket()
          ],
        ),
      ),
    );
  }
}
