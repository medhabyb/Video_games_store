import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:convert';

class ProductDetails extends StatefulWidget {

  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late String _id;
  late String _image;
  late String _title;
  late String _description;
  late int _price;
  late int _quantity;

  late SharedPreferences prefs;
  late Future<bool> gameInfo;

  final String _baseUrl = "10.0.2.2:9090";

  Future<bool> getGameInfo() async {
    prefs = await SharedPreferences.getInstance();

    _id = prefs.getString("gameId")!;
    _image = prefs.getString("gameImage")!;
    _title = prefs.getString("gameTitle")!;
    _description = prefs.getString("gameDescription")!;
    _price = prefs.getInt("gamePrice")!;
    _quantity = prefs.getInt("gameQuantity")!;

    return true;
  }

  @override
  void initState() {
    gameInfo = getGameInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gameInfo,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_title),
            ),
            body: Column(
              children: [
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Image.network("http://10.0.2.2:9090/img/" + _image, width: 460, height: 215)
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                  child: Text(_description),
                ),
                Text(_price.toString() + " TND", textScaleFactor: 3),
                Text("Exemplaires disponibles : " + _quantity.toString()),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
                label: const Text("Acheter", textScaleFactor: 1.5),
                icon: const Icon(Icons.shopping_basket_rounded),
                onPressed: () {
                  http.get(Uri.http(_baseUrl, "/library/" + prefs.getString("userId")! + "/" + _id))
                      .then((http.Response response) async {
                    if(response.statusCode == 200) {
                      Map<String, dynamic> countFromServer = json.decode(response.body);
                      if(int.parse(countFromServer["count"].toString()) != 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text("Information"),
                                content: Text("Vous possédez déjà ce jeu !"),
                              );
                            });
                      }
                      else {

                        Database database = await openDatabase(
                            join(await getDatabasesPath(), "gstore_esprit_database.db"),
                        );

                        Map<String, dynamic> game = {
                          "_id": _id,
                          "image": _image,
                          "price": _price
                        };

                        await database.insert("basket", game, conflictAlgorithm: ConflictAlgorithm.replace);

                        // List<Map<String, dynamic>> maps = await database.query("basket");
                        // print(maps);

                        Navigator.pop(context);
                      }
                    }
                    else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("Information"),
                              content: Text("Une erreur s'est produite. Veuillez réessayer !"),
                            );
                          });
                    }
                  });
                }
            ),
          );
        }
        else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Loading"),
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