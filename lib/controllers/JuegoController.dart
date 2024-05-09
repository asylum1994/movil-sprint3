import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiController {
  // Método para obtener datos de la API
  Future<List<Map<String, dynamic>>> getDataJuegoJugador(String email) async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.128.142:8000/api/participa?email=$email'));
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

  Future<List<Map<String, dynamic>>> getDataJuego(int idJuego) async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.128.142:8000/api/juegoData?id=$idJuego'));
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

  Future<List<Map<String, dynamic>>> verificarPostulacionJugador(
      String idJuego, String idTurno, String email) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.128.142:8000/api/verificarPostulacion?idJuego=$idJuego&idTurno=$idTurno&email=$email'));
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

  Future<List<Map<String, dynamic>>> getDataJugador(
      int idJuego, String email) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.128.142:8000/api/participaJugador?idJuego=$idJuego&email=$email'));
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

  Future<Map<String, dynamic>> putDataInvitacionJugador(
      int idJuego, String email, String estado) async {
    try {
      final response = await http.put(
        Uri.parse(
            "http://192.168.128.142:8000/api/participa/$idJuego"), // URL de la API para el registro de usuario
        body: {
          'email': email,
          'estado_participa': estado,
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

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getDataTurnoPostulacion(
      String email) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.128.142:8000/api/turnoJugador?email=$email'));
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

  Future<Map<String, dynamic>> registroPostulacion(
      String idJuego, String turno, String email, String monto) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.128.142:8000/api/postulacionJugador'), // URL de la API para el registro de usuario
        body: {
          'id_juego': idJuego,
          'turno': turno,
          'email': email,
          'monto': monto
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

  Future<List<Map<String, dynamic>>> getDataTurno(int idJuego) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.128.142:8000/api/obtenerGanadorTurno?id_juego=$idJuego'));
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

  Future<List<Map<String, dynamic>>> getDataJugadoresTurno(int idTurno) async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.128.142:8000/api/obtenerJugadoresTurno?id_turno=$idTurno'));
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

  Future<Map<String, dynamic>> actualizarPagoJugador(
      int id, String email) async {
    try {
      final response = await http.put(
        Uri.parse(
            "http://192.168.128.142:8000/api/actualizaPago/$id"), // URL de la API para el registro de usuario
        body: {
          'email': email,
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
}
