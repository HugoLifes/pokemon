import 'dart:convert';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pokemon/getPoke.dart';

import 'package:http/http.dart' as http;
import 'package:pokemon/loginMenu.dart';
import 'package:pokemon/pokePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  final String? user;
  String? email;
  ProfileScreen({Key? key, this.user = "hola", this.email}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

Future<Pokemons?> getPoke() async {
  Uri uri = Uri.https("raw.githubusercontent.com",
      "/Biuni/PokemonGO-Pokedex/master/pokedex.json");

  var response = await http.get(uri);

  if (response.statusCode == 200) {
    return pokemonsFromJson(response.body);
  } else {
    print(response.statusCode);
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Poke> poke = [];
  bool searchPoke = false;
  bool favorite = false;
  List<Poke> fav = [];
  final controller = FloatingSearchBarController();
  Poke? hi;
  List<Poke> yeah = [];
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  getData() async {
    await getPoke().then((value) async {
      for (int i = 0; i < value!.pokemon!.length; i++) {
        setState(() {
          poke.add(new Poke(
            name: value.pokemon![i].name,
            url: value.pokemon![i].img,
          ));
        });
      }
    });
  }

  @override
  void initState() {
    getData();
    addUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerScrimColor: Colors.grey.withOpacity(0.5),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(''),
                accountEmail: Text(widget.email!),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    widget.email![0],
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  signOut();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Busca y añade tus pokemons favoritos',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                final result = showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(poke: fav));

                result.then((value) => {
                      print(value),
                      if (poke.any(
                          (element) => element.name.toString().contains(value)))
                        {
                          print('here'),
                          setState(() {
                            if (mounted) {
                              yeah = poke
                                  .where((element) =>
                                      element.name.toString().contains(value))
                                  .toList();
                            }
                          }),
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PokePage(
                                    poke: yeah.first,
                                  )))
                        }
                    });
              },
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              child: Column(
                children: [
                  gridview(poke.length),
                ],
              ),
            )
          ],
        ));
  }

  gridview(int lenght) {
    return FloatingSearchBarScrollNotifier(
      child: AnimationLimiter(
        child: Container(
          //padding: EdgeInsets.only(top: 60),
          child: Expanded(
            flex: 1,
            child: GridView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: lenght,
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
                          onTap: () {
                            pokeFav(index);
                          },
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
                                          image:
                                              NetworkImage(poke[index].url!))),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(poke[index].name!),
                                  ],
                                )
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
      ),
    );
  }

  SharedPreferences? prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userId;

  /// cerrar sesion
  Future<String> signOut() async {
    await _auth.signOut();
    prefs = await SharedPreferences.getInstance();
    prefs!.setBool('auth', false);

    widget.email = null;
    Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginPage()), (route) => false)
        .then((value) => {
              Fluttertoast.showToast(
                  msg: "Cerro sesion",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 4,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0)
            });
    return 'User signed out';
  }

  Future<void> addUser() async {
    CollectionReference users = fireStore.collection('Usuarios');
    setState(() {
      userId = users.id;
    });
    return users
        .add({'Name': widget.email}).then((value) => {print('usersAdd')});
  }

  pokeFav(int index) async {
    CollectionReference id = fireStore.collection('Usuarios');
    DocumentReference parente = fireStore.collection('Usuarios').doc();

    setState(() {
      fav.add(Poke(name: poke[index].name, url: poke[index].url));
    });

    Fluttertoast.showToast(
        msg: "Se añadio a tus favoritos",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    /*  parente.set({
      'Name': [poke[index].name].toList(),
      'url': [poke[index].url].toList(),
    }).then((value) => {print('ok')}); */
  }
}

class Poke {
  String? name;
  String? url;
  String? images;
  Color? color;
  Icon? icon = Icon(Icons.star);
  bool fav;
  Poke(
      {this.url,
      this.name,
      this.images,
      this.icon,
      this.fav = false,
      this.color});
}

class CustomSearchDelegate extends SearchDelegate {
  List<Poke>? poke;

  CustomSearchDelegate({this.poke});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        progress: transitionAnimation,
        icon: AnimatedIcons.menu_home,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  /// construye los resultados de la busqueda
  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 90,
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 7, offset: Offset(0, 5))
            ]),
        child: Column(
          children: [Text(query)],
        ),
      ),
    );
  }

  /// construye posibles sugerencias de busqueda
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = poke
        ?.where((element) => element.name!.toLowerCase().startsWith(query))
        .toList();

    return ListView.builder(
      itemCount: suggestionsList?.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {
            query = suggestionsList![index].name!;

            close(
              context,
              query,
            );
          },
          leading: Image.network(suggestionsList![index].url!),
          title: RichText(
            text: TextSpan(
              text: suggestionsList[index].name!.substring(0, query.length),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: suggestionsList[index].name!.substring(query.length),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          subtitle: Text(suggestionsList[index].name!),
        );
      },
    );
  }
}
