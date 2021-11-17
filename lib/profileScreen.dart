import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pokemon/getPoke.dart';

import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final String user;
  ProfileScreen({Key? key, this.user = 'Hugo'}) : super(key: key);

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
                accountName: Text(widget.user),
                accountEmail: Text('@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    widget.user[0],
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
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Buscar',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(poke: poke));
              },
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            gridview(),
          ],
        ));
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
        automaticallyImplyBackButton: false,
        controller: controller,
        hint: 'Favoritos',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 800 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          query = controller.query;
        },
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: fav.map((poke) {
                  return Container(
                    height: 112,
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(poke.url!))),
                        ),
                        Text(poke.name!),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
        body: Stack(
          children: [
            Column(
              children: [],
            )
          ],
        ));
  }

  gridview() {
    return FloatingSearchBarScrollNotifier(
      child: AnimationLimiter(
        child: Container(
          //padding: EdgeInsets.only(top: 60),
          child: Expanded(
            flex: 1,
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
                          onTap: () {
                            setState(() {
                              fav.add(new Poke(
                                  url: poke[index].url,
                                  name: poke[index].name));
                            });

                            Fluttertoast.showToast(
                                msg: "Se añadio a tus favoritos",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 4,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
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
      icon: Icon(Icons.arrow_back),
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
          children: [
            Text(query),
          ],
        ),
      ),
    );
  }

  /// construye posibles sugerencias de busqueda
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList =
        poke?.where((p) => p.name!.toLowerCase().contains(query)).toList();

    return ListView.builder(
      itemCount: suggestionsList?.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {},
          leading: Icon(Icons.search),
          title: RichText(
            text: TextSpan(
              text: poke![index].name!.substring(0, query.length),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: poke![index].name!.substring(query.length),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          subtitle: Text(poke![index].name!),
        );
      },
    );
  }
}
