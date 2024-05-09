import 'dart:io';

import 'package:app_pasanaku/controllers/JuegoController.dart';
import 'package:app_pasanaku/views/JuegoIniciado.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagoTurno extends StatefulWidget {
  String image;
  int idTurno;
  PagoTurno({super.key, required this.image, required this.idTurno});

  @override
  State<PagoTurno> createState() => _PagoTurnoState();
}

class _PagoTurnoState extends State<PagoTurno> {
  String _image = "";
  String _email = "";
  final picker = ImagePicker();
  ApiController api = ApiController();

  @override
  void initState() {
    super.initState();
    _loadEmailFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("pago por QR")),
      body: pagoTurnoPage(),
    );
  }

  Widget pagoTurnoPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width * 0.9,
                color: Colors.amberAccent,
                child: Image.file(
                  File(widget.image),
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "ingresar monto",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 5))),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Detalle",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 5))),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    api
                        .actualizarPagoJugador(widget.idTurno, _email)
                        .then((value) => {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JuegoIniciado(
                                          id_juego: widget.idTurno,
                                        )),
                              ),
                            });
                  },
                  child: Text("Pagar"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadEmailFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ??
        ''; // Si no hay valor, asignamos un valor por defecto
    setState(() {
      _email = email;
    });
  }
}
