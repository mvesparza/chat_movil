import 'package:flutter/material.dart';
import 'pantalla_chat.dart';

class PantallaLogin extends StatefulWidget {
  @override
  _PantallaLoginState createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController controladorUsuario = TextEditingController();
  String errorMessage = ''; // Mensaje de error

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5), // Fondo gris claro similar a WhatsApp
      appBar: AppBar(
        backgroundColor: Color(0xFF075E54), // Color de WhatsApp
        title: Text('Chat Público', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título de la pantalla de login
            Text(
              'Bienvenido al Chat Público',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF075E54),
              ),
            ),
            SizedBox(height: 30),
            // Campo de texto para ingresar el nombre
            TextField(
              controller: controladorUsuario,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Ingresa tu nombre',
                hintStyle: TextStyle(color: Colors.grey),
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Color(0xFF075E54)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF075E54), width: 2),
                ),
                errorText: errorMessage.isNotEmpty ? errorMessage : null,
                errorStyle: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(height: 20),
            // Botón de ingresar al chat
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF075E54), // Color de WhatsApp
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (controladorUsuario.text.isEmpty) {
                  setState(() {
                    errorMessage = 'El nombre es obligatorio'; // Mostrar mensaje de error
                  });
                } else {
                  setState(() {
                    errorMessage = ''; // Limpiar mensaje de error
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaChat(usuario: controladorUsuario.text),
                    ),
                  );
                }
              },
              child: Text(
                'Ingresar al Chat',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
