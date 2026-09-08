import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

void exportJson(String content) {
  final bytes = utf8.encode(content);
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = 'bitacora_acceso.json';
  anchor.click();
  web.URL.revokeObjectURL(url);
}

Future<String?> importJson() {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = '.json,application/json';
  final completer = Completer<String?>();
  input.click();
  input.onChange.listen((_) {
    final files = input.files;
    if (files == null || files.length == 0) {
      completer.complete(null);
      return;
    }
    final reader = web.FileReader();
    reader.onLoadEnd.listen((_) {
      final content = reader.result?.dartify() as String?;
      completer.complete(content);
    });
    reader.readAsText(files.item(0)!);
  });
  return completer.future;
}
