import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:loader_overlay/loader_overlay.dart';
import 'package:glyphicon/glyphicon.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import 'package:shared_preferences/shared_preferences.dart';

class MakeNewPost extends StatefulWidget {
  // MakeNewPost({Key? key}) : super(key: key);

  @override
  _MakeNewPostState createState() => _MakeNewPostState();
}

class _MakeNewPostState extends State<MakeNewPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final titleController2 = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<String> file = [];
  List<Text>? nameFile = [];
  List<String>? nameFile2 = [];
  String? chosenValue;
  String? chosenValue2;
  String? chosenValue3;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool cargando = false;
  Uint8List? files;
  init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs!.getString('name');
      userId = prefs!.getString('userId');
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey[700],
        onPressed: () {
          //FocusScope.of(context).unfocus();
          if (cargando == true) {
            Fluttertoast.showToast(
                msg: "subiendo archivos",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 17.0);
          } else {
            if (file.length < 3) {
              Fluttertoast.showToast(
                  msg: "Selecciona 3 images minimo",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 17.0);
            } else {
              onSave().whenComplete(() => {
                    Navigator.of(context).pop(),
                    Fluttertoast.showToast(
                        msg: "Se subio con exito",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 17.0)
                  });
            }
          }
        },
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text('Nuevo Post'),
        automaticallyImplyLeading: false,
        elevation: 4.0,
        backgroundColor: Colors.blueGrey[700],
        leading: BackButton(),
        //leading: CloseButton(),
      ),
      body: GestureDetector(
        onTap: () {
          //FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 15),
                      child: Container(
                          height: 51,
                          width: MediaQuery.of(context).size.width / 10,
                          decoration: BoxDecoration(
                              color: Colors.grey[300], shape: BoxShape.circle),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width / 59),
                      child: Text('Hector Hugo',
                          style: (TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500))),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 6,
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.only(left: 50, top: 20),
                  child: Form(
                      key: _formKey2,
                      child: TextFormField(
                        controller: titleController2,
                        onFieldSubmitted: (_) => onSave(),
                        validator: (val) => val != null && val.isEmpty
                            ? 'Este campo no puede estar vacio'
                            : null,
                        autocorrect: true,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: "Titulo",
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Color(0xFF455A64))),
                        ),
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.only(left: 50, top: 20),
                  child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: titleController,
                        onFieldSubmitted: (_) => onSave(),
                        validator: (val) => val != null && val.isEmpty
                            ? 'Este campo no puede estar vacio'
                            : null,
                        autocorrect: true,
                        maxLines: 7,
                        decoration: InputDecoration(
                          labelText: "Algo para decir?",
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(color: Color(0xFF455A64))),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1000)
                        ],
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    drop('Marca'),
                    drop1(
                      'Año',
                      year,
                    ),
                    drop3(
                      'Modelo',
                      modelo,
                    ),
                  ],
                ),
                Divider(
                  color: Color(0xFF455A64).withOpacity(0.3),
                  thickness: 1.1,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                  child: InkWell(
                    onTap: () async {
                      await filePick();

                      /// funcion que toma el archivo y despues de terminar la funcion guarda el archivo en un arreglo
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Selecciona varios archivos',
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width / 20,
                                ),

                                /// si el arreglo de archivos no esta vacio muestra los archivos
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                  child: Row(
                    children: [
                      base64foto.isEmpty
                          ? Container()
                          : Container(
                              width: 100,
                              height: 200,
                              child: Image.memory(
                                base64foto[0],
                              )),
                      base64foto.length >= 2
                          ? Container(
                              width: 100,
                              height: 200,
                              child: Image.memory(
                                base64foto[1],
                              ))
                          : Container(),
                      base64foto.length >= 3
                          ? Container(
                              width: 100,
                              height: 200,
                              child: Image.memory(
                                base64foto[2],
                              ))
                          : Container(),
                      base64foto.length >= 4
                          ? Container(
                              width: 100,
                              height: 200,
                              child: Image.memory(
                                base64foto[3],
                              ))
                          : Container(),
                      base64foto.length >= 5
                          ? Container(
                              width: 100,
                              height: 200,
                              child: Image.memory(
                                base64foto[4],
                              ))
                          : Container()
                    ],
                  ),
                ),
                cargando == false
                    ? Container()
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            )
          ]),
        ),
      ),
    );
  }

  List<String> type = [
    'Toyota',
    'Nissan',
    'Ford',
  ];
  List<String> year = [
    '2019',
    '2018',
    '2017',
  ];
  List<String> modelo = [
    'Toyota',
    'Nissan',
    'Ford',
  ];

  drop(String text) {
    return Container(
      width: 130,
      height: 60,
      padding: EdgeInsets.only(top: 10),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: chosenValue,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: Colors.black,
        items: type.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: Text(
          "Marca",
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        onChanged: (value) {
          setState(() {
            chosenValue = value!;
          });
        },
      ),
    );
  }

  drop1(String text, List<String> val) {
    return Container(
      width: 130,
      height: 60,
      padding: EdgeInsets.only(top: 10),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: chosenValue2,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: Colors.black,
        items: modelo.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: Text(
          "Modelo",
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        onChanged: (value) {
          setState(() {
            chosenValue2 = value!;
          });
        },
      ),
    );
  }

  drop3(String text, List<String> val) {
    return Container(
      width: 130,
      height: 60,
      padding: EdgeInsets.only(top: 10),
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: chosenValue3,
        //elevation: 5,
        style: TextStyle(color: Colors.white),
        iconEnabledColor: Colors.black,
        items: year.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        hint: Text(
          "Año",
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        onChanged: (val) {
          setState(() {
            chosenValue3 = val!;
          });
        },
      ),
    );
  }

  var base64foto = [];
  List<XFile> itemImagesList = <XFile>[];
  SharedPreferences? prefs;
  var email;
  var userId;
  var marca;
  var model;
  var anio;

  Future onSave() async {
    final isValid = _formKey.currentState!.validate();
    final isValid2 = _formKey2.currentState!.validate();

    if (isValid2 && isValid) {
      if (chosenValue != null && chosenValue2 != null && chosenValue != null) {
        await sendingData(titleController2.text, titleController.text,
            chosenValue3!, chosenValue2!, chosenValue!);
      }
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  List urls = [];

  Future<void> sendingData(
    String titulo,
    String descrip,
    String year,
    String modelo,
    String marca,
  ) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference users = fireStore.collection('Hilos');

    return users.add({
      'idUser': '123123',
      'Name': 'Hugo',
      'Titulo': titulo,
      'comentario': descrip,
      'fecha': DateTime.now(),
      'like': false,
      'marca': marca,
      'modelo': modelo,
      'year': year,
      'img': urlPhoto,
      'img1': urlPhoto.isEmpty ? '' : urlPhoto[0],
      'img2': urlPhoto.length >= 2 ? urlPhoto[1] : '',
      'img3': urlPhoto.length >= 3 ? urlPhoto[2] : '',
      'img4': urlPhoto.length >= 4 ? urlPhoto[3] : '',
      'img5': urlPhoto.length >= 5 ? urlPhoto[4] : ''
    });
  }

  var filename;
  var progress;

  Future filePick() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      // file = result.files
      if (file.length < 5) {
        setState(() {
          files = result.files.first.bytes;
          filename = result.files.first.name;
          base64foto.add(result.files.first.bytes);
          file.add(result.files.first.name);
        });

        //file = result.paths.map((path) => File(path!)).toList();
        saveInfoAndSet();
        print(result.files.first.name);
      } else {
        Fluttertoast.showToast(
            msg: "limite excedido",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 17.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "No selecciono archivos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 17.0);
    }
  }

  saveInfoAndSet() async {
    for (int i = 0; i < base64foto.length; i++) {
      await uploadFile(i);
    }
  }

  List urlPhoto = [];

  Future uploadFile(int filex) async {
    setState(() {
      cargando = true;
    });
    Reference ref = FirebaseStorage.instance
        .ref('gs://pokemon-27552.appspot.com/')
        .child('files/${filename!}');

    ref
        .putData(
          await base64foto[filex],
          SettableMetadata(contentType: 'img/png'),
        )
        .snapshotEvents
        .listen((event) {
      setState(() {
        progress =
            ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
                    100)
                .roundToDouble();
        if (progress == 100) {
          cargando = false;
        }

        print('progreso: $progress');
      });
    });

    String? value = await ref.getDownloadURL();

    setState(() {
      urlPhoto.add(value);
    });
  }

  //usar en caso extremo
  uploadFile2() async {
    final storage = FirebaseStorage.instance;
    UploadTask taskUp = storage
        .ref('gs://pokemon-27552.appspot.com/')
        .child('files/${filename!}')
        .putData(files!);

    taskUp.snapshotEvents.listen((event) {
      setState(() {
        progress =
            ((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
                    100)
                .roundToDouble();

        print('progreso: $progress');
      });
    });
  }
}
