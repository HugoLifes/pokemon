import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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
    Uri url = Uri.parse('http://localhost:8080/phpLogin.php');

    // Store all data with Param Name.
    var data = {"Usuario": email, "Password": password};

    // Starting Web API Call.
    var response = await http.post(url, body: data);

    // Getting Server response into variable.
    var message = json.decode(response.body);

    print(message);
    // If the Response Message is Matched.
    if (message == "Success") {
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });
      Fluttertoast.showToast(
          msg: "Bienvenido!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.of(context).pushReplacementNamed('/screen2');
    } else {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      Fluttertoast.showToast(
          msg: "Esta cuenta ya existe",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Welcome!',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'ROBOTO'))),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Have alredy account?',
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
                  decoration: InputDecoration(hintText: 'Enter Your User'),
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
                  decoration: InputDecoration(hintText: 'Enter Your Password'),
                ),
              )),
          SizedBox(
            height: 10,
          ),
          GradientButton(
            increaseHeightBy: 20.0,
            increaseWidthBy: 100.0,
            elevation: 5,
            child: Text('Enter',
                style: TextStyle(
                    color: Colors.white,
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
            gradient: Gradients.buildGradient(Alignment.bottomCenter,
                Alignment.topCenter, [Colors.red, Colors.redAccent]),
            shadowColor: Gradients.backToFuture.colors.last.withOpacity(0.25),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/screen1');
              },
              child: Text(
                'Not Have account?, register please.',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.black,
                    fontFamily: 'ROBOTO'),
              )),
          Visibility(
              visible: visible,
              child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: CircularProgressIndicator())),
        ],
      ),
    ));
  }
}
