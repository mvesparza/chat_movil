import 'package:flutter/material.dart';
import 'views/pantalla_login.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Público',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PantallaLogin(),
    );
  }
}
