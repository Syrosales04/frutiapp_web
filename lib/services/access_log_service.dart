import 'dart:convert';
import '../models/access_record.dart';

class AccessLogService {
  final List<AccessRecord> _records = [];

  List<AccessRecord> get records => _records;

  void add(AccessRecord record) {
    _records.add(record);
  }

  String exportJson() {
    final listMap = _records.map((r) => r.toJson()).toList();
    return jsonEncode(listMap);
  }

  void importJson(String jsonStr) {
    final List<dynamic> listMap = jsonDecode(jsonStr);
    _records.clear();
    for (var item in listMap) {
      _records.add(AccessRecord.fromJson(item));
    }
  }
}