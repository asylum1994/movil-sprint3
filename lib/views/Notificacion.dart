import 'package:app_pasanaku/controllers/JuegoController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Notificacion extends StatefulWidget {
  const Notificacion({super.key});

  @override
  State<Notificacion> createState() => _NotificacionState();
}

class _NotificacionState extends State<Notificacion> {
  ApiController api = new ApiController();
  String _email = "";
  int _monto = 0;

  bool isLoadingInvitacion = false;
  bool isLoadingPostulacion = false;
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadEmailFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de carriles (tabs)
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notificaciones'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Invitaciones'),
              Tab(text: 'Postulaciones'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenido del primer carril (tab)
            _NotificationInvitacionPage(),
            // Contenido del segundo carril (tab)
            _NotificationPostulacionPage(),
          ],
        ),
      ),
    );
  }

  Widget _NotificationInvitacionPage() {
    return FutureBuilder(
        future: api.getDataJuegoJugador(_email),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: listCardInvitacion(snapshot.data),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  List<Widget> listCardInvitacion(List<Map<String, dynamic>>? snapshot) {
    List<Widget> listTemp = [];
    snapshot?.forEach((element) {
      if (element['estado_juego'] == 'pendiente') {
        Widget temp = _cardInvitacionJuego(element['nombre'], element['monto'],
            element['fecha_inicio'], element['periodo'], element['id_juego']);
        listTemp.add(temp);
      }
    });
    return listTemp;
  }

  Widget _cardInvitacionJuego(
      String nombre, int monto, String fecha, String periodo, int idJuego) {
    return Container(
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(width: 3)),
        child: ListTile(
          leading: Icon(Icons.gamepad_rounded),
          trailing: IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text("HOLA $_email !"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'estamos emocionados de invitarte a participar de nuestro juego de pasanaku'),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                                "detalle del juego : \n monto: $monto Bs. \n fecha de inicio : $fecha  \n periodo de pago : $periodo")
                          ],
                        ));
                  });
            },
          ),
          title: Text(
            'INVITACION',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          subtitle: Column(children: [
            Text(
              "Unete al pasanaku  !!! : $nombre",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            FutureBuilder(
                future: api.getDataJugador(idJuego, _email),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data[0]['estado_participa'] == "aceptado") {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "INVITACION ACEPTADA !!!",
                          style: TextStyle(color: Colors.green),
                        ),
                      );
                    } else if (snapshot.data[0]['estado_participa'] ==
                        "rechazado") {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "INVITACION RECHAZADA !!!",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return !isLoadingInvitacion
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoadingInvitacion = true;
                                    });

                                    await api.putDataInvitacionJugador(
                                        idJuego, _email, "aceptado");

                                    setState(() {
                                      isLoadingInvitacion = false;
                                    });
                                  },
                                  child: Text('aceptar'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoadingInvitacion = true;
                                    });
                                    await api.putDataInvitacionJugador(
                                        idJuego, _email, "rechazado");
                                    setState(() {
                                      isLoadingInvitacion = false;
                                    });
                                  },
                                  child: Text('rechazar'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                )
                              ],
                            )
                          : const LinearProgressIndicator();
                    }
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: LinearProgressIndicator(),
                    );
                  }
                }),
            SizedBox(
              height: 10,
            )
          ]),
        ),
      ),
    );
  }

  Widget _cardPostulacionJuego(int idJuego, int monto, String nombre, int turno,
      String fechaInicio, String fechaFin) {
    return Container(
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(width: 3)),
        child: ListTile(
          leading: Icon(Icons.gamepad_rounded),
          title: Text(
            'Postulacion',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          subtitle: Column(children: [
            Text(
              'se el ganador del turno # $turno  del juego pasanaku: "$nombre" postulando con un monto de dinero',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            FutureBuilder(
                future: api.verificarPostulacionJugador(
                    idJuego.toString(), turno.toString(), _email),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: !isLoadingPostulacion
                                ? Column(
                                    children: [
                                      TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              _monto = (int.parse(value));
                                            });
                                          },
                                          decoration: InputDecoration(
                                              hintText:
                                                  "monto minimo es ${monto * 0.01}  Bs.",
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black12)))),
                                      ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isLoadingPostulacion = true;
                                            });
                                            await api.registroPostulacion(
                                                idJuego.toString(),
                                                turno.toString(),
                                                _email,
                                                _monto.toString());
                                            setState(() {
                                              isLoadingPostulacion = false;
                                            });
                                          },
                                          child: const Text("Postular"))
                                    ],
                                  )
                                : const LinearProgressIndicator(),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              "gracias por postular !!!",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: LinearProgressIndicator(),
                    );
                  }
                }),
          ]),
        ),
      ),
    );
  }

  Widget _NotificationPostulacionPage() {
    return FutureBuilder(
        future: api.getDataTurnoPostulacion(_email),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: _listCardPostulacion(snapshot.data),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  List<Widget> _listCardPostulacion(List<Map<String, dynamic>>? snapshot) {
    List<Widget> listPostulacion = [];
    snapshot?.forEach((element) {
      Widget temp = _cardPostulacionJuego(
          element['id'],
          element['monto'],
          element['nombre'],
          element['nro_turno'],
          element['fecha_inicio'],
          element['fecha_fin']);
      listPostulacion.add(temp);
    });
    return listPostulacion;
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
