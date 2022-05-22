import 'package:flutter/material.dart';
import 'package:pokemon/profileScreen.dart';

class PokePage extends StatefulWidget {
  final Poke? poke;
  String? titulo;
  String? descrip;
  PokePage({Key? key, this.poke, this.titulo, this.descrip}) : super(key: key);

  @override
  _PokePageState createState() => _PokePageState();
}

class _PokePageState extends State<PokePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Regresar',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.greenAccent),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40, left: 50),
              child: Text('${widget.titulo}'),
            ),
            Container(
              padding: EdgeInsets.only(top: 40, left: 50),
              child: Text(
                '${widget.descrip}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
