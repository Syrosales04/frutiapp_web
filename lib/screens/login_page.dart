import 'package:flutter/material.dart';

import '../services/access_log_service.dart';
import '../services/json_file_service.dart';
import '../services/preferences_service.dart';
import 'bitacora_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _logService = AccessLogService();
  final _preferencesService = PreferencesService();
  bool _recordarme = false;
  bool _mostrarPassword = false;
  bool _cargandoPreferencias = true;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final user = await _preferencesService.loadRememberedUser();
    if (!mounted) return;
    setState(() {
      _correoController.text = user ?? '';
      _recordarme = user != null;
      _cargandoPreferencias = false;
    });
  }

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _ingresar() async {
    if (!_formKey.currentState!.validate()) return;
    final correo = _correoController.text.trim();
    final autorizado =
        correo == 'admin@frutiapp.com' && _passwordController.text == '123456';
    _logService.addRecord(correo, autorizado);

    if (_recordarme) {
      await _preferencesService.saveRememberedUser(correo);
    } else {
      await _preferencesService.clearRememberedUser();
    }

    if (!mounted) return;
    if (autorizado) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomePage(logService: _logService)),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Acceso rechazado')));
    }
  }

  void _exportarBitacora() {
    JsonFileService.exportJson(_logService.exportJson());
  }

  Future<void> _importarBitacora() async {
    final content = await JsonFileService.importJson();
    if (content == null || !mounted) return;
    try {
      _logService.importJson(content);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitácora importada correctamente')),
      );
    } on FormatException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('JSON inválido: ${error.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FrutiApp - Control de Acceso')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                const Icon(Icons.lock_person, size: 64, color: Colors.green),
                const SizedBox(height: 12),
                const Text('FrutiApp', style: TextStyle(fontSize: 28)),
                const Text('Iniciar sesión', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _correoController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Ingrese el correo'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_mostrarPassword,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: _mostrarPassword
                                ? 'Ocultar contraseña'
                                : 'Mostrar contraseña',
                            icon: Icon(
                              _mostrarPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => _mostrarPassword = !_mostrarPassword,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.length < 6
                            ? 'La contraseña debe tener al menos 6 caracteres'
                            : null,
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Recordarme'),
                        value: _recordarme,
                        onChanged: _cargandoPreferencias
                            ? null
                            : (value) =>
                                  setState(() => _recordarme = value ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _ingresar,
                          icon: const Icon(Icons.login),
                          label: const Text('Ingresar'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 40),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BitacoraPage(logService: _logService),
                        ),
                      ),
                      icon: const Icon(Icons.history),
                      label: const Text('Ver bitácora'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _exportarBitacora,
                      icon: const Icon(Icons.download),
                      label: const Text('Exportar JSON'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _importarBitacora,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Importar JSON'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
