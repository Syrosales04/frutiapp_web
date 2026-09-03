import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

/// Servicio encargado de consumir el endpoint REST público de prueba
/// y transformar la respuesta JSON en una lista de [Producto].
class ProductoService {
  static const String _endpoint =
      'https://jsonplaceholder.typicode.com/posts';

  /// Realiza la solicitud GET al endpoint y retorna la lista de productos.
  ///
  /// Flujo conceptual (ver sección 6.9 del laboratorio):
  ///   Solicitud -> Esperar respuesta -> Procesar JSON -> Actualizar interfaz
  Future<List<Producto>> cargarProductos() async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(response.body) as List<dynamic>;

      // Se limita a los primeros 10 elementos para que el catálogo
      // sea representativo sin sobrecargar la pantalla Home.
      final List<dynamic> subset = datos.take(10).toList();

      return subset
          .map((item) => Producto.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception('No se pudo cargar la información');
  }
}
