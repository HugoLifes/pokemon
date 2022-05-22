import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pokemon/getPoke.dart';

import 'package:http/http.dart' as http;
import 'package:pokemon/loginMenu.dart';
import 'package:pokemon/main.dart';
import 'package:pokemon/newPost.dart';
import 'package:pokemon/pokePage.dart';
import 'package:pokemon/profileEdit.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  final String? user;
  String? email;
  ProfileScreen({Key? key, this.user, this.email}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

someData(iniciado, nombre, userId) async {
  await MyApp.init();

  print('aqui $iniciado');
  prefs!.setBool('auth', iniciado);
  prefs!.setString('name', nombre);
  prefs!.setString('userId', userId);
}

//llamada api
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
  List yeah = [];
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String? email;
  String? id;
  String? chosenValue;
  String? chosenValue2;
  List? datalist = [];
  int countSearch = 0;
  bool esPremium = true;

  hellow() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs!.getString('name');
      id = prefs!.getString('userId');
    });
    print('email:$email');
  }

  Future getData() async {
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

  List hilo = [];
  List text = [];
  init() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('Hilos');

    await ref.get().then((value) => {
          for (var result in value.docs) {hilo.add(result.data())},
          print(value.docs.map((e) => {print(e.data())}))
        });

    print('aqui1:${hilo.length}');
    return hilo;
  }

  downloadImg(List url) async {
    List<Uint8List>? bytes;
    for (int i = 0; i < url.length; i++) {}
    ByteData imageData =
        await NetworkAssetBundle(Uri.parse(url[0]['img'].toString())).load("");
    bytes!.add(imageData.buffer.asUint8List());
    return bytes;
  }

  @override
  void initState() {
    super.initState();
    hellow();

    //init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          elevation: 7,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MakeNewPost()));
          },
          backgroundColor: Colors.red,
          label: const Text('Nuevo Hilo'),
          icon: Icon(Icons.post_add_rounded),
        ),
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
                title: Container(
                    child: Row(
                  children: [
                    Icon(
                      Icons.home,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Home'),
                  ],
                )),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Container(
                    child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Profile'),
                  ],
                )),
                onTap: () {
                  Navigator.of(context)
                    ..pop()
                    ..push(MaterialPageRoute(builder: (_) => EditProfile()));
                },
              ),
              ListTile(
                title: Container(
                    child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.purple,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Logout'),
                  ],
                )),
                onTap: () {
                  signOut().then((value) => {
                        Fluttertoast.showToast(
                            msg: "Cerro sesion con exito",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0)
                      });
                },
              ),
              ListTile(
                title: Container(
                    child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Hazte Premium!'),
                  ],
                )),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Container(
                    child: Row(
                  children: [
                    Icon(
                      Icons.shield,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Be validator'),
                  ],
                )),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Busqueda',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                countSearch++;

                if (countSearch == 10) {
                  return alerta5();
                }

                //
                final result = showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(data: datalist));

                result.then((value) => {
                      print(value),
                      if (datalist!.any((element) =>
                          element['modelo'].toString().contains(value)))
                        {
                          print('here'),
                          setState(() {
                            if (mounted) {
                              yeah = datalist!
                                  .where((element) => element['modelo']
                                      .toString()
                                      .contains(value))
                                  .toList();
                            }
                          }),
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PokePage(
                                    //poke: yeah.first,
                                    titulo: yeah.first['Titulo'],
                                    descrip: yeah.first['comentario'],
                                  )))
                        }
                    });
              },
            ),
          ],
        ),
        body: FutureBuilder(
            future: init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                datalist = snapshot.data as List;
                //colecData(datalist!);
                print(datalist);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.height,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Tu historial',
                                      style: TextStyle(fontSize: 26),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(
                                      Icons.history,
                                      size: 70,
                                      color: Colors.blueAccent,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          /*   Container(
                            height: 150,
                            width: MediaQuery.of(context).size.height,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Co',
                                      style: TextStyle(fontSize: 26),
                                    ),
                                    Icon(
                                      Icons.cake,
                                      size: 70,
                                      color: Colors.lightGreen,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ) */
                        ],
                      ),
                    )
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  alerta5() {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'Si, continuar',
          style: TextStyle(color: Colors.red[900]),
        ));
    Widget backButton = TextButton(
        onPressed: () {
          Navigator.of(context)..pop();
        },
        child: Text(
          'Regresar',
          style: TextStyle(color: Colors.orange),
        ));
    AlertDialog alert = AlertDialog(
      actions: [backButton, okButton],
      title: Text(
        'Atención!',
        style: TextStyle(
          fontSize: 25,
        ),
      ),
      content: Container(
        width: 140,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atencion!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Text('Necesita ser usuario premium, le interesa unirse?')
          ],
        ),
      ),
    );

    showDialog(
        context: context, builder: (_) => alert, barrierDismissible: false);
  }

  List<String> words = ['Tu Historial', 'Top 10 errores'];
  gridview(int lenght) {
    return FloatingSearchBarScrollNotifier(
      child: AnimationLimiter(
        child: Container(
          //padding: EdgeInsets.only(top: 60),

          child: Expanded(
            child: GridView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: words.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 10.0,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 20),
                itemBuilder: (_, int index) {
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 4,
                    duration: Duration(seconds: 3),
                    position: 2,
                    child: ScaleAnimation(
                      scale: 0.9,
                      child: FadeInAnimation(
                        child: InkWell(
                          onTap: () {
                            //pokeFav(index);
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('${words[index]}'),
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
  Future signOut() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setBool('auth', false);

    //widget.email = null;
    await _auth.signOut();

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  Future<void> addUser() async {
    CollectionReference users = fireStore.collection('Usuarios');
    setState(() {
      userId = users.id;
    });
    return users
        .add({'Name': widget.email}).then((value) => {print('usersAdd')});
  }

  List<Hilo> listHilo = [];
  colecData(List add) {
    for (int i = 0; i < add.length; i++) {
      listHilo.add(Hilo(
          name: add[i]['Name'],
          titulo: add[i]['Titulo'],
          descrip: add[i]['comentario'],
          time: add[i]['fecha'],
          marca: add[i]['marca'],
          modelo: add[i]['modelo'],
          year: add[i]['year'],
          img: add[i]['img'] != null ? add[i]['img'].toList() : null));
    }
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
  List? data;
  Uint8List? memo;

  CustomSearchDelegate({this.data});
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
    final suggestionsList = data
        ?.where((element) => element['marca'].toLowerCase().startsWith(query))
        .toList();

    return ListView.builder(
      itemCount: suggestionsList?.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {
            query = suggestionsList![index]['marca'];

            close(
              context,
              query,
            );
          },
          leading: Icon(Icons.newspaper),
          title: RichText(
            text: TextSpan(
              text:
                  suggestionsList![index]['modelo']!.substring(0, query.length),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text:
                      suggestionsList[index]['marca']!.substring(query.length),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          subtitle: Text(suggestionsList[index]['year']),
        );
      },
    );
  }
}

class Hilo {
  String? titulo;
  String? descrip;
  String? name;
  List<dynamic>? img;
  Timestamp? time;
  String? marca;
  String? modelo;
  String? year;

  Hilo(
      {this.descrip,
      this.img,
      this.marca,
      this.modelo,
      this.name,
      this.time,
      this.titulo,
      this.year});
}
