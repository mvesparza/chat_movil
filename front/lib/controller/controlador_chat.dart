import 'dart:convert';
import 'dart:async'; // Importar para usar Timer
import 'package:http/http.dart' as http;
import '../model/mensaje.dart';

class ControladorChat {
  final String apiUrl = 'http://10.40.25.88:8002/messages';
  List<Mensaje> _mensajes = []; // Lista interna de mensajes

  // Obtener mensajes desde el backend
  Future<List<Mensaje>> obtenerMensajes() async {
    final respuesta = await http.get(Uri.parse(apiUrl));
    if (respuesta.statusCode == 200) {
      List<dynamic> data = json.decode(respuesta.body);
      _mensajes = data.map((msg) => Mensaje.fromJson(msg)).toList();
      return _mensajes;
    } else {
      throw Exception('Error al obtener mensajes');
    }
  }

  // Enviar un nuevo mensaje
  Future<void> enviarMensaje(Mensaje mensaje) async {
    await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(mensaje.toJson()),
    );
    // Actualizar la lista de mensajes después de enviar uno
    _mensajes.add(mensaje);
  }

  // Polling para obtener los mensajes cada X segundos (por ejemplo, 3 segundos)
  void iniciarPolling(Function(List<Mensaje>) actualizarMensajes) {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      try {
        List<Mensaje> mensajes = await obtenerMensajes();
        actualizarMensajes(mensajes);
      } catch (e) {
        print('Error al obtener mensajes: $e');
      }
    });
  }
}
