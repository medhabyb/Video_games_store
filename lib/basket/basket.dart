import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'element_info.dart';

class Basket extends StatefulWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  int _totalPrice = 0;

  late Future<bool> _fetchedBasket;

  final List<LocalBasket> _basket = [];

  Future<bool> fetchBasket() async {

    Database database = await openDatabase(
        join(await getDatabasesPath(), "gstore_esprit_database.db")
    );

    List<Map<String, dynamic>> maps = await database.query("basket");
    for(int i = 0; i < maps.length; i++) {
      _basket.add(LocalBasket(maps[i]["_id"], maps[i]["image"], int.parse(maps[i]["price"].toString())));
      _totalPrice += int.parse(maps[i]["price"].toString());
    }

    return true;
  }

  @override
  void initState() {
    _fetchedBasket = fetchBasket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchedBasket,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if(snapshot.hasData) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Total : " + _totalPrice.toString() + " TND", textScaleFactor: 1.5,)
                ],
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: const Divider(color: Colors.red)
              ),
              Expanded(
                  child: ListView.builder(
                    itemCount: _basket.length,
                    itemBuilder: (BuildContext context,int index) {
                      return ElementInfo(_basket[index].id, _basket[index].image, _basket[index].price);
                    },
                  )
              )
            ],
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

class LocalBasket {
  final String id;
  final String image;
  final int price;

  LocalBasket(this.id, this.image, this.price);

  @override
  String toString() {
    return 'LocalBasket{id: $id, image: $image, price: $price}';
  }
}