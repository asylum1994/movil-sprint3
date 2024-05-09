// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth {
  // Método para obtener datos de la API
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.128.142:8000/api/auth?email=${email}&password=${password}'));

      if (response.statusCode == 200) {
        // Decodificar el JSON y devolver los datos
        // List<dynamic> jsonData = json.decode(response.body);
        //jsonData.cast<Map<String, dynamic>>();
        Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData;
      } else {
        // Si falla la solicitud, lanzar una excepción
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      // Capturar y manejar errores
      print('Error: $e');
      rethrow; // Lanzar la excepción nuevamente para que pueda ser manejada por el código que llamó a este método
    }
  }

  Future<List<Map<String, dynamic>>> getUser(String email) async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.128.142:8000/api/getUsuario?email=$email'));

      if (response.statusCode == 200) {
        // Decodificar el JSON y devolver los datos
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        // Si falla la solicitud, lanzar una excepción
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      // Capturar y manejar errores
      print('Error: $e');
      rethrow; // Lanzar la excepción nuevamente para que pueda ser manejada por el código que llamó a este método
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password, String token) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.128.142:8000/api/auth'), // URL de la API para el registro de usuario
        body: {
          'name': name,
          'email': email,
          'password': password,
          'token': token,
        },
      );
      if (response.statusCode == 200) {
        // Decodificar el JSON y devolver los datos
        Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData;
      } else {
        // Si falla la solicitud, lanzar una excepción
        throw Exception('Failed to register user');
      }
    } catch (e) {
      // Capturar y manejar errores
      print('Error: $e');
      rethrow; // Lanzar la excepción nuevamente para que pueda ser manejada por el código que llamó a este método
    }
  }

  Future<Map<String, dynamic>> putDataImageQRJugador(
      String email, String urlImage) async {
    try {
      final response = await http.put(
        Uri.parse(
            "http://192.168.128.142:8000/api/editQRJugador/$email"), // URL de la API para el registro de usuario
        body: {
          'imageQR': urlImage,
        },
      );
      if (response.statusCode == 200) {
        // Decodificar el JSON y devolver los datos
        Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData;
      } else {
        // Si falla la solicitud, lanzar una excepción
        throw Exception('Failed to register user');
      }
    } catch (e) {
      // Capturar y manejar errores
      print('Error: $e');
      rethrow; // Lanzar la excepción nuevamente para que pueda ser manejada por el código que llamó a este método
    }
  }

  Future<List<Map<String, dynamic>>> getImageJugador(String email) async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.128.142:8000/api/obtenerQRJugador/$email'));
      if (response.statusCode == 200) {
        // Decodificar el JSON y devolver los datos
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        // Si falla la solicitud, lanzar una excepción
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      // Capturar y manejar errores
      print('Error: $e');
      rethrow; // Lanzar la excepción nuevamente para que pueda ser manejada por el código que llamó a este método
    }
  }
}
