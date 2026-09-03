import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const FrutiApp());
}

/// Widget raíz de la aplicación FrutiApp Web.
class FrutiApp extends StatelessWidget {
  const FrutiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FrutiApp Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
