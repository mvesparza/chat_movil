import 'package:cloud_firestore/cloud_firestore.dart';


class Mensaje {
  final String remitente;
  final String texto;
  final String hora;

  Mensaje({required this.remitente, required this.texto, required this.hora});

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      remitente: json['remitente'],
      texto: json['texto'],
      hora: json['hora'],
    );
  }

  factory Mensaje.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Mensaje(
      remitente: data['remitente'],
      texto: data['texto'],
      hora: data['hora'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remitente': remitente,
      'texto': texto,
      'hora': hora,
    };
  }
}
