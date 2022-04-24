import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Pokemon> fetchPokemon() async {
  // Consumimos el recurso para ditto de Pokemon API
  final response = await http.get('https://pokeapi.co/api/v2/pokemon/ditto');

  if (response.statusCode == 200) {
    return Pokemon.fromJson(json.decode(response.body));
  } else {
    throw Exception('Problema encontrando ditto');
  }
}

class Pokemon {
  // Estamos personalizando esta clase para solo leer la propiedad name del recurso API
  final int id;
  final String name;

  Pokemon({this.id, this.name});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
    );
  }
}

void main() => runApp(MyApp(post: fetchPokemon()));

class MyApp extends StatelessWidget {
  final Future<Pokemon> post;

  MyApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consumiendo Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ejemplo de HTTP call'),
        ),
        body: Center(
          child: FutureBuilder<Pokemon>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.name);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
