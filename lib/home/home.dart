import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product_info.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<bool> fetchedGames;

  final List<Product> _products = [];

  final String _baseUrl = "10.0.2.2:9090";

  Future<bool> fetchGames() async {
    http.Response response = await http.get(Uri.http(_baseUrl, "/game"));

    List<dynamic> gamesFromServer = json.decode(response.body);

    for(int i = 0; i < gamesFromServer.length; i++) {
      Map<String, dynamic> gameFromServer = gamesFromServer[i];
      _products.add(Product(gameFromServer["_id"], gameFromServer["image"], gameFromServer["title"],
          gameFromServer["description"], int.parse(gameFromServer["price"].toString()),
          int.parse(gameFromServer["quantity"].toString())));
    }

    return true;
  }

  @override
  void initState() {
    fetchedGames = fetchGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedGames,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
            itemCount: _products.length,
            itemBuilder: (BuildContext context,int index) {
              return ProductInfo(_products[index].id, _products[index].image, _products[index].title, _products[index].description,
                  _products[index].price, _products[index].quantity);
            },
          );
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}