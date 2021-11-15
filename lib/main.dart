import 'package:flutter/material.dart';
import 'package:pokemon/loginMenu.dart';
import 'package:pokemon/profileScreen.dart';
import 'package:pokemon/signUpMenu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        '/screen2': (BuildContext context) => ProfileScreen()
      },
    );
  }
}
