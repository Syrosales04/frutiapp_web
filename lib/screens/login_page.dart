import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:web/web.dart' as web;

import 'home_page.dart'; // Mismo directorio (lib/screens)
import '../models/access_record.dart'; // Sube a lib/ y entra a models
import '../services/access_log_service.dart'; // Sube a lib/ y entra a services


/// Pantalla 1: Control de acceso con bitácora JSON.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AccessLogService _logService = AccessLogService();

  bool _recordarme = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Validación del correo: no vacío, contiene '@' y contiene '.'
  String? _validarCorreo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese el correo';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Correo no válido';
    }
    return null;
  }

  // Validación de la contraseña: mínimo 6 caracteres.
  String? _validarPassword(String? value) {
    if (value == null || value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  void _registrarIntento({required bool exitoso}) {
    final correo = _correoController.text.trim();
    // Registro seguro: ÚNICAMENTE guardamos usuario, fecha/hora y si fue exitoso (NO la contraseña)
    _logService.add(
      AccessRecord(
        usuario: correo,
        fechaHora: DateTime.now(),
        exitoso: exitoso,
      ),
    );
  }

  void _ingresar() {
    final esValido = _formKey.currentState!.validate();

    // Registramos en la bitácora el intento (exitoso o fallido)
    _registrarIntento(exitoso: esValido);

    if (esValido) {
      setState(() {});
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      setState(() {});
    }
  }

  void _exportarBitacora() {
    if (_logService.records.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay registros en la bitácora para exportar.')),
      );
      return;
    }

    final contenido = _logService.exportJson();
    final base64Data = base64Encode(utf8.encode(contenido));

    web.HTMLAnchorElement()
      ..href = 'data:application/json;base64,$base64Data'
      ..setAttribute('download', 'bitacora_accesos.json')
      ..click();
  }

  Future<void> _importarBitacora() async {
    const typeGroup = XTypeGroup(
      label: 'JSON',
      extensions: ['json'],
      mimeTypes: ['application/json'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;

    try {
      final contenido = await file.readAsString();
      setState(() {
        _logService.importJson(contenido);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitácora importada correctamente')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al importar archivo JSON: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 187, 187),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título "FrutiApp" dentro de un Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        child: const Column(
                          children: [
                            Icon(
                              Icons.local_grocery_store,
                              size: 48,
                              color: Colors.green,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'FrutiApp',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              'Inicia sesión para continuar',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campo correo electrónico
                      TextFormField(
                        controller: _correoController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: _validarCorreo,
                      ),
                      const SizedBox(height: 16),

                      // Campo contraseña
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: _validarPassword,
                      ),
                      const SizedBox(height: 8),

                      // Checkbox "Recordarme" dentro de un Row
                      Row(
                        children: [
                          Checkbox(
                            value: _recordarme,
                            onChanged: (bool? value) {
                              setState(() {
                                _recordarme = value ?? false;
                              });
                            },
                          ),
                          const Text('Recordarme'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Botón Ingresar
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _ingresar,
                              child: const Text('Ingresar'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Botones de Exportar e Importar Bitácora JSON
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _exportarBitacora,
                              icon: const Icon(Icons.download, size: 18),
                              label: const Text('Exportar JSON'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _importarBitacora,
                              icon: const Icon(Icons.upload_file, size: 18),
                              label: const Text('Importar JSON'),
                            ),
                          ),
                        ],
                      ),

                      // Sección para visualización de la bitácora
                      if (_logService.records.isNotEmpty) ...[
                        const Divider(height: 32),
                        Text(
                          'Bitácora de Accesos (${_logService.records.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 180),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _logService.records.length,
                            itemBuilder: (context, index) {
                              final record = _logService.records[index];
                              return ListTile(
                                dense: true,
                                leading: Icon(
                                  record.exitoso
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: record.exitoso
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                title: Text(
                                  record.usuario.isEmpty
                                      ? '(sin correo)'
                                      : record.usuario,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                subtitle: Text(
                                  record.fechaHora.toString().split('.')[0],
                                  style: const TextStyle(fontSize: 10),
                                ),
                                trailing: Text(
                                  record.exitoso ? 'ÉXITO' : 'FALLIDO',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: record.exitoso
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}