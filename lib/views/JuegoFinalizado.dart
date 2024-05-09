import 'package:flutter/material.dart';

class JuegoFinalizado extends StatefulWidget {
  int id_juego;
  JuegoFinalizado({super.key, required this.id_juego});

  @override
  State<JuegoFinalizado> createState() => _JuegoFinalizadoState();
}

class _JuegoFinalizadoState extends State<JuegoFinalizado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Juego Finalizado")),
      body: const Center(child: Text("no esta finalizado")),
    );
  }
}
