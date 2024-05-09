import 'package:app_pasanaku/Home.dart';
import 'package:app_pasanaku/controllers/AuthController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_pasanaku/views/Register.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Auth auth = new Auth();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginPage(),
    );
  }

  Widget loginPage() {
    return Center(
      child: bodyLogin(),
    );
  }

  Widget bodyLogin() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(children: [
        const Text(
          'Ingresa a la App',
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        const SizedBox(
          height: 30,
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
              auth.login(email, password).then((value) => {
                    if (value['status'] == 'true')
                      {
                        _saveEmailToSharedPreferences(email),
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        ),
                      }
                  });
            },
            child: Text("ingresar")),
        const SizedBox(
          height: 20,
        ),
        Text('todavia no tienes una cuenta?'),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Register()),
              );
            },
            child: const Text('create una !!')),
      ]),
    );
  }

  Future<void> _saveEmailToSharedPreferences(String email) async {
    // Guardar el correo electrónico en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    print('Correo electrónico guardado en SharedPreferences: $email');
  }
}
