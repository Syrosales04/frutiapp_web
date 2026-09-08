import 'package:flutter/material.dart';

import '../services/access_log_service.dart';

class BitacoraPage extends StatelessWidget {
  final AccessLogService logService;

  const BitacoraPage({super.key, required this.logService});

  @override
  Widget build(BuildContext context) {
    final records = logService.records.reversed.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Bitácora de accesos')),
      body: records.isEmpty
          ? const Center(child: Text('Aún no hay intentos registrados.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                final color = record.exitoso ? Colors.green : Colors.red;
                return Card(
                  child: ListTile(
                    leading: Icon(
                      record.exitoso ? Icons.check_circle : Icons.cancel,
                      color: color,
                    ),
                    title: Text(record.usuario),
                    subtitle: Text(record.fechaHora.toLocal().toString()),
                    trailing: Text(
                      record.exitoso ? 'AUTORIZADO' : 'RECHAZADO',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
