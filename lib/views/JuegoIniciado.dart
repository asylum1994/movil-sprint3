import 'dart:io';
import 'dart:typed_data';

import 'package:app_pasanaku/views/PagoTurno.dart';
import 'package:flutter/material.dart';
import 'package:app_pasanaku/controllers/AuthController.dart';
import 'package:app_pasanaku/controllers/JuegoController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class JuegoIniciado extends StatefulWidget {
  int id_juego;
  JuegoIniciado({super.key, required this.id_juego});

  @override
  State<JuegoIniciado> createState() => _JuegoIniciadoState();
}

class _JuegoIniciadoState extends State<JuegoIniciado> {
  final picker = ImagePicker();
  ApiController api = ApiController();
  Auth auth = Auth();
  String _urlImage = "";
  String _image = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(title: const Text("Juego Iniciado")),
        body: juegoIniciadoPage());
  }

  Widget juegoIniciadoPage() {
    return FutureBuilder(
        future: api.getDataTurno(widget.id_juego),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data == null) {
            return const Center(child: Text("no existe data"));
          } else {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: listaTurnoJuego(snapshot.data!),
            );
          }
        });
  }

  List<Widget> listaTurnoJuego(List<Map<String, dynamic>> snapshot) {
    List<Widget> tempList = [];
    snapshot.forEach((element) {
      Widget temp = cardTurno(
          element['id'],
          element['nro_turno'],
          element['ganador'],
          element['monto'],
          element['fecha_inicio'],
          element['fecha_fin']);
      tempList.add(temp);
    });
    return tempList;
  }

  Widget cardTurno(int idTurno, int nroTurno, String? ganador, int? monto,
      String fechaInicio, String fechaFin) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Turno # $nroTurno',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    (ganador == null || monto == null)
                        ? Container()
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                getImage(idTurno);
                              });
                            },
                            child: Row(
                              children: const [
                                Text("pagar"),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(Icons.monetization_on_rounded)
                              ],
                            ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Inicio: $fechaInicio",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "Fin: $fechaFin",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                (ganador == null || monto == null)
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "el turno no ha empezado",
                            style: TextStyle(fontSize: 25, color: Colors.red),
                          ),
                        ),
                      )
                    : ListTile(
                        title: Text(
                          "Ganador",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        subtitle: Text(
                          "$ganador \n$monto BS.",
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: FutureBuilder(
                            future: auth.getUser(ganador),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.data == null) {
                                return Text('no hay data');
                              } else {
                                return snapshot.data![0]['imageQR'] == null
                                    ? const Text(
                                        'no hay QR',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          setState(() {
                                            saveImage(
                                                snapshot.data![0]['imageQR']);
                                          });
                                        },
                                        child: Text(
                                          "Save QR",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      );
                              }
                            }),
                      ),
                const Divider(
                  thickness: 3,
                ),
                FutureBuilder(
                    future: api.getDataJugadoresTurno(idTurno),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data == null) {
                        return const Center(child: Text("no existe data"));
                      } else {
                        return DataTable(columns: const [
                          DataColumn(label: Text("Jugador")),
                          DataColumn(label: Text("Cuota"))
                        ], rows: listJugadoresTurno(snapshot.data));
                      }
                    })
              ],
            ),
          ))),
    );
  }

  List<DataRow> listJugadoresTurno(List<Map<String, dynamic>>? data) {
    List<DataRow> listTemp = [];
    if (data != null) {
      data.forEach((element) {
        DataRow temp = DataRow(cells: [
          DataCell(Text(element['jugador'])),
          DataCell(Text(
            element['pago'],
            style: TextStyle(
                color: element['pago'] == 'pendiente'
                    ? Colors.blue
                    : element['pago'] == 'realizado'
                        ? Colors.green
                        : Colors.red,
                fontWeight: FontWeight.bold),
          ))
        ]);
        listTemp.add(temp);
      });
      return listTemp;
    }
    return listTemp;
  }

  Future saveImage(String url) async {
    final response = await GallerySaver.saveImage(url);
    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("imagen descargada"),
        duration: Duration(seconds: 2),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("fallo !!! vuelva a intentar"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future getImage(int idTurno) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile.path;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PagoTurno(
              image: _image,
              idTurno: idTurno,
            ),
          ),
        );
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }
}
