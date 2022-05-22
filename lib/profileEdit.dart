import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final correoController = TextEditingController();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final apellido = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 7.0,
        title: Text('Editar Perfil'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        leading: CloseButton(),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.save,
                size: 30,
              ))
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
                onTap: () async {
                  await filePick();
                },
                child: Column(
                  children: [
                    Container(
                      child: CircleAvatar(
                        child: file.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              )
                            : Image.memory(
                                files!,
                                fit: BoxFit.fill,
                              ),
                        backgroundColor: Colors.grey.withOpacity(1.0),
                        radius: 50,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.height * 0.4,
                              child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: correoController,
                                    onFieldSubmitted: (_) => {},
                                    validator: (val) =>
                                        val != null && val.isEmpty
                                            ? 'Este campo no puede estar vacio'
                                            : null,
                                    autocorrect: true,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      labelText: "Correo",
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                              color: Color(0xFF455A64))),
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(8)
                                    ],
                                  ))),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.height * 0.4,
                              child: Form(
                                  key: _formKey2,
                                  child: TextFormField(
                                    controller: nombre,
                                    onFieldSubmitted: (_) => {},
                                    validator: (val) =>
                                        val != null && val.isEmpty
                                            ? 'Este campo no puede estar vacio'
                                            : null,
                                    autocorrect: true,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      labelText: "Nombre",
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                              color: Color(0xFF455A64))),
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(8)
                                    ],
                                  )))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.height * 0.4,
                              child: Form(
                                  key: _formKey3,
                                  child: TextFormField(
                                    controller: apellido,
                                    onFieldSubmitted: (_) => {},
                                    validator: (val) =>
                                        val != null && val.isEmpty
                                            ? 'Este campo no puede estar vacio'
                                            : null,
                                    autocorrect: true,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      labelText: "Apellido",
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                              color: Color(0xFF455A64))),
                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(8)
                                    ],
                                  )))
                        ],
                      ),
                    ),
                  ],
                ))
          ]),
        ),
      ),
    );
  }

  var progress;
  var filename;
  List file = [];
  Uint8List? files;

  Future filePick() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      // file = result.files
      if (file.length <= 1) {
        setState(() {
          files = result.files.first.bytes;
          filename = result.files.first.name;
          file.add(result.files.first.name);
        });

        //file = result.paths.map((path) => File(path!)).toList();

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
