import 'package:flutter/material.dart';
import 'package:pokemon/profileScreen.dart';

class PokePage extends StatefulWidget {
  final Poke? poke;
  PokePage({Key? key, this.poke}) : super(key: key);

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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40, left: 50),
              child: Image.network(
                widget.poke!.url!,
                height: 300,
                width: 300,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 40, left: 50),
              child: Text(
                widget.poke!.name!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
