import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:http/http.dart' as http;
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
  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future register() async {
    print(emailController.text);
    Uri url = Uri.parse("http://localhost:8080/register.php");
    var response = await http.post(
      url,
      body: {
        "Usuario": emailController.text.toString(),
        "Password": passwordController.text.toString(),
      },
    );

    var data = json.encode(response.body);
    if (data == "Error") {
      Fluttertoast.showToast(
          msg: "Esta cuenta ya existe",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Bienvenido!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pushReplacementNamed('/screen2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleBar(),
      ),
      body: vistaMenu(),
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

  SingleChildScrollView vistaMenu() {
    return SingleChildScrollView(
        child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Create account with us',
                  style: TextStyle(fontSize: 21))),
          Container(
              width: 280,
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: emailController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Introduce tu contraseña';
                    }
                  },
                  autocorrect: true,
                  decoration:
                      InputDecoration(hintText: 'Enter Your Email Here'),
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
                      return 'Introduce tu contraseña';
                    }
                  },
                  controller: passwordController,
                  autocorrect: true,
                  obscureText: true,
                  decoration:
                      InputDecoration(hintText: 'Enter Your Password Here'),
                ),
              )),
          botonRegistrar(),
          Visibility(
              visible: visible,
              child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: CircularProgressIndicator())),
        ],
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
      gradient: Gradients.buildGradient(Alignment.bottomCenter,
          Alignment.topCenter, [Colors.red, Colors.redAccent]),
      shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.25),
    );
  }
}
