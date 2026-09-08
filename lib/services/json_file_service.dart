import 'json_file_service_stub.dart'
    if (dart.library.js_interop) 'json_file_service_web.dart'
    as platform;

class JsonFileService {
  static void exportJson(String content) => platform.exportJson(content);

  static Future<String?> importJson() => platform.importJson();
}
