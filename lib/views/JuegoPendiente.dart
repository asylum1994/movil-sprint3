import 'package:app_pasanaku/controllers/JuegoController.dart';
import 'package:flutter/material.dart';

class JuegoPendiente extends StatefulWidget {
  int id_juego;
  JuegoPendiente({super.key, required this.id_juego});

  @override
  State<JuegoPendiente> createState() => _JuegoPendienteState();
}

class _JuegoPendienteState extends State<JuegoPendiente> {
  ApiController api = ApiController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(
          title: const Text("Juego Pendiente"),
        ),
        body: juegoPendientePage());
  }

  Widget juegoPendientePage() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: api.getDataJuego(widget.id_juego),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data == null) {
                  return Center(child: Text('no existen datos'));
                } else {
                  return Center(
                    child: Column(
                      children: [
                        detalleJuego(
                          snapshot.data![0]['nombre'],
                          snapshot.data![0]['monto'],
                          snapshot.data![0]['periodo'],
                          snapshot.data![0]['fecha_inicio'],
                        ),
                        const Divider(thickness: 3),
                        participantesJuego(snapshot.data)
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget detalleJuego(
      String nombre, int monto, String periodo, String fecha_inicio) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(children: [
            const Text(
              "Juego: ",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            Text(
              nombre,
              style: TextStyle(
                fontSize: 20,
              ),
            )
          ]),
          Row(children: [
            const Text(
              "Monto: ",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            Text(
              "$monto Bs.",
              style: TextStyle(
                fontSize: 20,
              ),
            )
          ]),
          Row(children: [
            const Text(
              "Periodo: ",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            Text(
              periodo,
              style: TextStyle(
                fontSize: 20,
              ),
            )
          ]),
          Row(children: [
            const Text(
              "Fecha Inicio: ",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            Text(
              fecha_inicio,
              style: TextStyle(
                fontSize: 20,
              ),
            )
          ]),
        ],
      ),
    );
  }

  Widget participantesJuego(List<Map<String, dynamic>>? snapshot) {
    return Column(
      children: [
        Text(
          "Participantes",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Colors.redAccent),
        ),
        DataTable(columns: const [
          DataColumn(
              label: Text(
            "Jugador",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          )),
          DataColumn(
              label: Text(
            "Invitacion",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ))
        ], rows: tableParticipantes(snapshot!))
      ],
    );
  }

  List<DataRow> tableParticipantes(List<Map<String, dynamic>> snapshot) {
    List<DataRow> listTemp = [];
    snapshot.forEach((element) {
      DataRow temp = DataRow(cells: [
        DataCell(Text(element['email'])),
        DataCell(Text(
          element['estado_participa'],
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: element['estado_participa'] == 'pendiente'
                  ? Colors.blue
                  : element['estado_participa'] == 'aceptado'
                      ? Colors.green
                      : Colors.red),
        ))
      ]);
      listTemp.add(temp);
    });
    return listTemp;
  }
}
