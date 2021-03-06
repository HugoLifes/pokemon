import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../profileScreen.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // For CircularProgressIndicator.
  bool visible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  List hilos = [];
  Future register() async {
    print(emailController.text);
    print(lastNameController.text);
    print(passwordController.text);
    print(nameController.text);
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference users = fireStore.collection('Usuarios');

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      print(userCredential.user);
      print(userCredential.additionalUserInfo);
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
          // Navigate to Profile Screen & Sending Email to Next Screen.
          prefs.setBool('auth', true);
          users.add({
            'Apellido': lastNameController.text,
            'Nombre': nameController.text,
            'ReferidoKuchau': false,
            'contrase??a': passwordController.text,
            'correo': emailController.text,
            'esPremium': false,
          });

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ProfileScreen(
                    user: '',
                    email: event.email,
                  )));
        } else {
          print('no');
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Fluttertoast.showToast(
            msg: "Contrase??a corta",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'email-already-in-use') {
        return Fluttertoast.showToast(
            msg: "Ya existe esa cuenta",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> init() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    fireStore
        .collection('Hilos')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Formato de Registro'),
          actions: [],
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/mate.png'),
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
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      )),
                  Text('Busquedas',
                      style: GoogleFonts.getFont('Press Start 2P',
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            )
          ],
        ));
  }

  vistaMenu(Size size) {
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.only(top: 200, left: 40),
      width: size.width / 3,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Crea tu cuenta', style: TextStyle(fontSize: 21))),
            Container(
                width: 280,
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: emailController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Introduce tu correo';
                      }
                    },
                    autocorrect: true,
                    decoration: InputDecoration(hintText: 'Registra tu email'),
                  ),
                )),
            Container(
                width: 280,
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey3,
                  child: TextFormField(
                    controller: nameController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Introduce tu nombre';
                      }
                    },
                    autocorrect: true,
                    decoration: InputDecoration(hintText: 'Registra tu nombre'),
                  ),
                )),
            Container(
                width: 280,
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey4,
                  child: TextFormField(
                    controller: lastNameController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Introduce tu apellido';
                      }
                    },
                    autocorrect: true,
                    decoration:
                        InputDecoration(hintText: 'Registra tu apellido'),
                  ),
                )),
            Container(
                width: 280,
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey2,
                  child: TextFormField(
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Introduce tu contrase??a';
                      } else {
                        if (v.length < 5) {
                          return 'Contrase??a muy corta';
                        }
                      }
                    },
                    controller: passwordController,
                    autocorrect: true,
                    obscureText: true,
                    decoration:
                        InputDecoration(hintText: 'Registra tu contrase??a'),
                  ),
                )),
            botonRegistrar(),
            SizedBox(
              height: 10,
            ),
            Visibility(
                visible: visible,
                child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    child: CircularProgressIndicator())),
          ],
        ),
      ),
    ));
  }

  GradientButton botonRegistrar() {
    return GradientButton(
      increaseHeightBy: 10.0,
      increaseWidthBy: 100.0,
      elevation: 5,
      child: Text('Create Account',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      callback: () {
        if (_formKey.currentState!.validate() &&
            _formKey3.currentState!.validate() &&
            _formKey4.currentState!.validate() &&
            _formKey2.currentState!.validate()) {
          register();
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
    );
  }
}
