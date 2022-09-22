import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late String? _username;
  late String? _email;
  late String? _password;
  late String? _birth;
  late String? _address;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final String _baseUrl = "10.0.2.2:9090";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inscription"),
      ),
      body: Form(
        key: _keyForm,
        child: ListView(
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Image.asset("assets/images/minecraft.jpg", width: 460, height: 215)
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Username"),
                onSaved: (String? value) {
                  _username = value;
                },
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Le username ne doit pas etre vide";
                  }
                  else if(value.length < 5) {
                    return "Le username doit avoir au moins 5 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Email"),
                onSaved: (String? value) {
                  _email = value;
                },
                validator: (String? value) {
                  String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                  if(value == null || value.isEmpty) {
                    return "L'adresse email ne doit pas etre vide";
                  }
                  else if(!RegExp(pattern).hasMatch(value)) {
                    return "L'adresse email est incorrecte";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Mot de passe"),
                onSaved: (String? value) {
                  _password = value;
                },
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "Le mot de passe ne doit pas etre vide";
                  }
                  else if(value.length < 5) {
                    return "Le mot de passe doit avoir au moins 5 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Année de naissance"),
                onSaved: (String? value) {
                  _birth = value;
                },
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "L'année de naissance ne doit pas etre vide";
                  }
                  else if(int.parse(value.toString()) > 2021) {
                    return "L'année de naissance est incorrecte";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Adresse de facturation"),
                onSaved: (String? value) {
                  _address = value;
                },
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "L'adresse email ne doit pas etre vide";
                  }
                  else if(value.length < 20) {
                    return "Le mot de passe doit avoir au moins 20 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("S'inscrire"),
                  onPressed: () {
                    if(_keyForm.currentState!.validate()) {
                      _keyForm.currentState!.save();

                      Map<String, dynamic> userData = {
                        "username": _username,
                        "password" : _password,
                        "email" : _email,
                        "birth" : _birth,
                        "address" : _address
                      };

                      Map<String, String> headers = {
                        "Content-Type": "application/json; charset=UTF-8"
                      };

                      http.post(Uri.http(_baseUrl, "/user/signup"), headers: headers, body: json.encode(userData))
                          .then((http.Response response) {
                        if(response.statusCode == 201) {
                          Navigator.pushReplacementNamed(context, "/");
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
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  child: const Text("Annuler"),
                  onPressed: () {
                    _keyForm.currentState!.reset();
                    Navigator.pushReplacementNamed(context, "/signin");
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
