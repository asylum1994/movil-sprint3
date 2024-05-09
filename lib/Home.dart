import 'package:app_pasanaku/controllers/JuegoController.dart';
import 'package:app_pasanaku/notifications/push_notifications.dart';
import 'package:app_pasanaku/views/Configuracion.dart';
import 'package:app_pasanaku/views/JuegoFinalizado.dart';
import 'package:app_pasanaku/views/JuegoIniciado.dart';
import 'package:app_pasanaku/views/JuegoPendiente.dart';
import 'package:app_pasanaku/views/Login.dart';
import 'package:app_pasanaku/views/Notificacion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  State<Home> createState() => _HomeState();
}

@override
class _HomeState extends State<Home> {
  String _email = "";
  ApiController api = new ApiController();
  PushNotificationProvider provider = new PushNotificationProvider();
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadEmailFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_email),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Configuracion()),
                    );
                  },
                  icon: Icon(Icons.settings)),
              IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: Icon(Icons.refresh_outlined)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notificacion()),
                    );
                  },
                  icon: const Icon(Icons.notifications_sharp)),
              IconButton(
                  onPressed: () {
                    _logout().then((value) => {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          )
                        });
                  },
                  icon: const Icon(Icons.logout_rounded)),
              const SizedBox(
                width: 5,
              ),
            ],
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(
                  Icons.gamepad_sharp,
                  color: Color.fromARGB(255, 22, 22, 18),
                ),
                text: 'Pendiente',
              ),
              Tab(
                icon: Icon(
                  Icons.gamepad_sharp,
                  color: Colors.green,
                ),
                text: 'Iniciado',
              ),
              Tab(
                icon: Icon(
                  Icons.gamepad_sharp,
                  color: Colors.red,
                ),
                text: 'Finalizado',
              )
            ]),
          ),
          body: TabBarView(children: [
            FutureBuilder(
                future: api.getDataJuegoJugador(_email),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    return listaJuegoPendiente(
                        snapshot.data, 'aceptado', Colors.blue);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            //////////////////////////////////////////////////
            FutureBuilder(
                future: api.getDataJuegoJugador(_email),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    return listaJuegoIniciado(
                        snapshot.data, 'iniciado', Colors.green);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            ////////////////////////////////////////////////////////////
            FutureBuilder(
                future: api.getDataJuegoJugador(_email),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    return listaJuegoFinalizado(
                        snapshot.data, 'finalizado', Colors.red);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ]),
        ));
  }

  Widget listaJuegoPendiente(
      List<Map<String, dynamic>>? objetos, String estado, Color color) {
    return ListView(
        padding: EdgeInsets.all(20),
        children: listCardJuego(objetos, estado, color));
  }

  Widget listaJuegoIniciado(
      List<Map<String, dynamic>>? objetos, String estado, Color color) {
    return ListView(
        padding: EdgeInsets.all(20),
        children: listCardJuego(objetos, estado, color));
  }

  Widget listaJuegoFinalizado(
      List<Map<String, dynamic>>? objetos, String estado, Color color) {
    return ListView(
        padding: EdgeInsets.all(20),
        children: listCardJuego(objetos, estado, color));
  }

  List<Widget> listCardJuego(
      List<Map<String, dynamic>>? objetos, String estado, Color color) {
    List<Widget> temp = [];
    objetos?.forEach((element) {
      if (element['estado_participa'] == estado &&
          element['estado_juego'] == 'pendiente') {
        Widget tempCard = cardJuego(
            element['id_juego'],
            element['nombre'],
            element['monto'],
            element['fecha_inicio'],
            color,
            element['estado_juego']);
        temp.add(tempCard);
      } else if (element['estado_juego'] == estado) {
        Widget tempCard = cardJuego(
            element['id_juego'],
            element['nombre'],
            element['monto'],
            element['fecha_inicio'],
            color,
            element['estado_juego']);
        temp.add(tempCard);
      }
    });
    return temp;
  }

  Widget cardJuego(int id_juego, String nombre, int monto, String fecha,
      Color color, String estadoJuego) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => estadoJuego == 'iniciado'
                ? JuegoIniciado(id_juego: id_juego)
                : estadoJuego == 'pendiente'
                    ? JuegoPendiente(
                        id_juego: id_juego,
                      )
                    : JuegoFinalizado(id_juego: id_juego),
          ),
        );
      },
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: color, width: 4.0)),
          elevation: 30,
          shadowColor: color,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: ListTile(
              leading: const Icon(
                Icons.games_outlined,
                color: Colors.amber,
              ),
              title: Text(
                nombre,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'monto: ' + monto.toString() + ' Bs.',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'inicio: ' + fecha,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
              trailing: const Icon(
                Icons.people_sharp,
                color: Colors.amber,
              ),
            ),
          )),
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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
  }
}
