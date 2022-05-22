import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/main.dart';
import 'package:pokemon/signUpMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profileScreen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // For CircularProgressIndicator.
  bool visible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? user;
  bool? iniciado;

  Future userLogin() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    print(email);
    print(password);
    // SERVER LOGIN API URL
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      auth.authStateChanges().listen((event) {
        if (event!.email != null) {
          Fluttertoast.showToast(
              msg: "Bienvenido!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          print(userCredential.user!.uid);
          someData(true, event.email, userCredential.user!.uid);
          // Navigate to Profile Screen & Sending Email to Next Screen.
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ProfileScreen(
                    user: userCredential.user!.uid,
                    email: event.email,
                  )));
        } else {
          print('no');
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "No se encontro el usuario",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          visible = false;
        });
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Contraseña erronea",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/kushau.jpg'),
                      fit: BoxFit.cover))),
          vistaMenu(size),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(top: 300, right: 100),
            child: Column(
              children: [
                Text('Kushau',
                    style: GoogleFonts.getFont(
                      'Press Start 2P',
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    )),
                Text('Busquedas',
                    style: GoogleFonts.getFont('Press Start 2P',
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row titleBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('BUSQUEDA',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        SizedBox(
          width: 5,
        ),
        Text('POKEMON',
            style: TextStyle(
                color: Colors.yellowAccent[700],
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold))
      ],
    );
  }

  vistaMenu(Size size) {
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.only(top: 200, left: 40),
      width: size.width / 3,
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Hola!',
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'ROBOTO'))),
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Ya tienes cuenta?',
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'ROBOTO'))),
            Container(
                width: 280,
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: emailController,
                    autocorrect: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Introduce un usuario';
                      }
                    },
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                )),
            Container(
                width: 280,
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey2,
                  child: TextFormField(
                    controller: passwordController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Introduce tu contraseña';
                      }
                    },
                    autocorrect: true,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Contraseña'),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            GradientButton(
              increaseHeightBy: 20.0,
              increaseWidthBy: 100.0,
              elevation: 5,
              child: Text('Inicia',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              callback: () {
                if (_formKey.currentState!.validate() &&
                    _formKey2.currentState!.validate()) {
                  userLogin();
                } else {
                  Fluttertoast.showToast(
                      msg: "Campos vacios",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              gradient: Gradients.buildGradient(
                  Alignment.centerLeft, Alignment.centerRight, [
                Colors.yellow,
                Colors.yellow,
                Colors.yellow.shade700,
                Colors.redAccent
              ]),
              shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.25),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SignUpPage()));
                },
                child: Text(
                  'Registrate con nosotros',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontFamily: 'ROBOTO'),
                )),
            Visibility(
                visible: visible,
                child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: CircularProgressIndicator(color: Colors.black))),
          ],
        ),
      ),
    ));
  }
}
