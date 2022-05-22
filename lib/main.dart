import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon/loginMenu.dart';
import 'package:pokemon/profileEdit.dart';
//import 'package:pokemon/newPost.dart';
import 'package:pokemon/profileScreen.dart';
import 'package:pokemon/signUpMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'newPost.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

SharedPreferences? prefs;

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;
  bool? iniciado;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();

      setState(() {
        _initialized = true;
      });
      print('here');
    } catch (e) {
      print('here2');
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    MyApp.init();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => LoginPage(),
        '/screen1': (BuildContext context) => SignUpPage(),
        '/screen2': (BuildContext context) => ProfileScreen(),
        '/screen3': (BuildContext context) => MakeNewPost(),
        '/screen4': (BuildContext context) => EditProfile()
      },
    );
  }
}
