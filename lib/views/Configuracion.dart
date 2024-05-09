import 'dart:io';

import 'package:app_pasanaku/controllers/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';

class Configuracion extends StatefulWidget {
  const Configuracion({super.key});

  @override
  State<Configuracion> createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  Auth api = Auth();
  String _email = "";
  final picker = ImagePicker();
  String _image = "";
  String _ImageQR = "";

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEmailFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subir Imagen QR"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  getImage();
                });
              },
              icon: Icon(
                Icons.file_upload_outlined,
                size: 30,
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Center(
        child: Column(children: [
          SizedBox(
            height: 50,
          ),
          Card(
              elevation: 30,
              child: Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.9,
                  color: Colors.amberAccent,
                  child: _image != ""
                      ? Image.file(
                          File(_image),
                          fit: BoxFit.fill,
                        )
                      : FutureBuilder(
                          future: api.getImageJugador(_email),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.data == null) {
                              return const Center(
                                  child: Text('no se encontraron datos'));
                            } else if (snapshot.data![0]['imageQR'] != null) {
                              return Image.network(
                                snapshot.data![0]['imageQR'],
                                fit: BoxFit.fill,
                              );
                            } else {
                              return const Center(
                                  child: Text("sube una imagen QR"));
                            }
                          }))), //container image
          SizedBox(
            height: 20,
          ),
          _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _uploadImageQR();
                    });
                  },
                  child: const Text("Guardar"))
        ]),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

  Future _uploadImageQR() async {
    if (_image == "") return;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String filePath = 'images/$fileName.jpg';

    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref().child(filePath);

    print(reference);

    try {
      setState(() {
        _isLoading = true;
      });
      await reference.putFile(File(_image));
      _ImageQR = await reference.getDownloadURL();
      print("_imageQR se guardo");
      api.putDataImageQRJugador(_email, _ImageQR).then((value) => {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                content: Text('se guardo correctamente la imagen !!'),
              ),
            ),
          });
      setState(() {
        _isLoading = false;
      });
      print(_ImageQR);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<String> getImageUrl() async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/image.jpg'); // Ruta de la imagen en Firebase Storage
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('Error getting image URL: $e');
    }
  }

  Future<void> _loadEmailFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ??
        ''; // Si no hay valor, asignamos un valor por defecto
    setState(() {
      _email = email;
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
  }
}
