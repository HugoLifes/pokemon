import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pokemon/getPoke.dart';

import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final String user;
  ProfileScreen({Key? key, this.user = ''}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

Future<Pokemons?> getPoke() async {
  Uri uri = Uri.parse(
      'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json');

  var response = await http.get(uri);

  if (response.statusCode == 200) {
    return pokemonsFromJson(response.body);
  } else {
    print(response.statusCode);
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Poke> poke = [];

  getData() async {
    await getPoke().then((value) async {
      for (int i = 0; i < value!.pokemon!.length; i++) {
        setState(() {
          poke.add(new Poke(
              name: value.pokemon![i].name, url: value.pokemon![i].img));
        });
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Buscalos a todos!'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Text('Helo'),
                gridview(),
              ],
            )
          ],
        ));
  }

  gridview() {
    return AnimationLimiter(
      child: Container(
        child: Expanded(
          child: GridView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: poke.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 1.5,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (_, int index) {
                return AnimationConfiguration.staggeredGrid(
                  columnCount: poke.length,
                  duration: Duration(seconds: 3),
                  position: 2,
                  child: ScaleAnimation(
                    scale: 0.9,
                    child: FadeInAnimation(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 10,
                                    offset: Offset(0, 5))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(poke[index].url!))),
                              ),
                              Text(poke[index].name!)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class Poke {
  String? name;
  String? url;
  String? images;
  Poke({this.url, this.name, this.images});
}
