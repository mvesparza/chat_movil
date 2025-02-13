import 'package:flutter/material.dart';
import '../controller/controlador_chat.dart';
import '../model/mensaje.dart';

class PantallaChat extends StatefulWidget {
  final String usuario;

  PantallaChat({required this.usuario});

  @override
  _PantallaChatState createState() => _PantallaChatState();
}

class _PantallaChatState extends State<PantallaChat> {
  final ControladorChat _controladorChat = ControladorChat();
  final TextEditingController _controladorMensaje = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Mensaje> _mensajes = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _iniciarPolling();
    _notificarIngreso(); // Notificar cuando el usuario ingresa
  }

  @override
  void dispose() {
    super.dispose();
    _notificarSalida(); // Notificar cuando el usuario salga
  }

  void _iniciarPolling() {
    _controladorChat.iniciarPolling((mensajes) {
      setState(() {
        _mensajes = mensajes;
      });
      _desplazarHaciaAbajo();
    });
  }

  void _notificarIngreso() {
    final mensaje = Mensaje(
      remitente: 'Sistema',
      texto: '${widget.usuario} ha ingresado al chat',
      hora: DateTime.now().toIso8601String(),
    );
    _controladorChat.enviarMensaje(mensaje);
  }

  void _notificarSalida() {
    final mensaje = Mensaje(
      remitente: 'Sistema',
      texto: '${widget.usuario} ha abandonado el chat',
      hora: DateTime.now().toIso8601String(),
    );
    _controladorChat.enviarMensaje(mensaje);
  }

  void _enviarMensaje() async {
    if (_controladorMensaje.text.isEmpty) {
      setState(() {
        errorMessage = 'No puedes enviar un mensaje vacío';
      });
    } else {
      setState(() {
        errorMessage = '';
      });
      final mensaje = Mensaje(
        remitente: widget.usuario,
        texto: _controladorMensaje.text,
        hora: DateTime.now().toIso8601String(),
      );
      await _controladorChat.enviarMensaje(mensaje);
      _controladorMensaje.clear();
    }
  }

  void _desplazarHaciaAbajo() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        backgroundColor: Color(0xFF075E54),
        title: Text('Chat Público', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final msg = _mensajes[index];
                final isOwnMessage = msg.remitente == widget.usuario;

                // Verificamos si el mensaje es de "Sistema" (usuario que indica que alguien ha ingresado)
                bool isNotification = msg.remitente == 'Sistema';

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Align(
                    alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        // Si es una notificación, usamos colores invertidos
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          decoration: BoxDecoration(
                            color: isNotification ? Colors.black : (isOwnMessage ? Color(0xFF075E54) : Colors.white),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            msg.texto,
                            style: TextStyle(
                              color: isNotification ? Colors.white : (isOwnMessage ? Colors.white : Colors.black),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          msg.remitente,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          _formatearHora(msg.hora),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorMensaje,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Escribe un mensaje...',
                      hintStyle: TextStyle(color: Colors.grey),
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
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF075E54)),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatearHora(String fecha) {
    final hora = DateTime.parse(fecha);
    return "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}";
  }
}
