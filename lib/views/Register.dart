import 'package:app_pasanaku/controllers/AuthController.dart';
import 'package:app_pasanaku/views/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Auth auth = new Auth();
  FirebaseMessaging provider = FirebaseMessaging.instance;
  String name = "";
  String email = "";
  String password = "";
  String token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider.getToken().then((value) => {token = value!});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: registerPage(),
    );
  }

  Widget registerPage() {
    return Center(
      child: bodyRegister(),
    );
  }

  Widget bodyRegister() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(children: [
        const Text(
          'create una cuenta',
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        const SizedBox(
          height: 30,
        ),
        TextField(
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
              hintText: "ingresar name",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.account_circle_outlined)),
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
        ),
        const SizedBox(
          height: 30,
        ),
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
              hintText: "ingresar Email",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined)),
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
        ),
        const SizedBox(
          height: 30,
        ),
        TextField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          decoration: const InputDecoration(
              hintText: "ingresar password",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.password_outlined)),
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              auth.register(name, email, password, token).then((value) => {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    )
                  });
            });
          },
          child: Text('Registrar'),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text('ya tienes una cuenta ?'),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: const Text('ingresa a la app')),
      ]),
    );
  }
}
