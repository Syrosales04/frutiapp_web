import 'dart:convert';

import '../models/access_record.dart';

class AccessLogService {
  final List<AccessRecord> _records = [];

  List<AccessRecord> get records => _records;

  void add(AccessRecord record) {
    _records.add(record);
  }

  // Método para registrar accesible directamente desde el login
  void addRecord(String usuario, bool exitoso) {
    _records.add(
      AccessRecord(
        usuario: usuario,
        fechaHora: DateTime.now(),
        exitoso: exitoso,
      ),
    );
  }

  String exportJson() {
    final listMap = _records.map((r) => r.toJson()).toList();
    return jsonEncode(listMap);
  }

  void importJson(String jsonStr) {
    final decoded = jsonDecode(jsonStr);
    if (decoded is! List) {
      throw const FormatException('El archivo debe contener una lista JSON');
    }

    final imported = decoded.map<AccessRecord>((item) {
      if (item is! Map) {
        throw const FormatException('La lista contiene un registro inválido');
      }
      return AccessRecord.fromJson(Map<String, dynamic>.from(item));
    }).toList();

    _records
      ..clear()
      ..addAll(imported);
  }
}
