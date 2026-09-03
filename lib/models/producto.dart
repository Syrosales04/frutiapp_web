/// Modelo que representa un producto del catálogo de FrutiApp.
///
/// Los datos provienen de https://jsonplaceholder.typicode.com/posts
/// y se transforman conceptualmente:
///   title -> nombre del producto
///   id    -> precio simulado (precio = id * 100)
class Producto {
  final int id;
  final String nombre;
  final int precio;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
  });

  /// Crea un [Producto] a partir de un mapa JSON proveniente del endpoint.
  factory Producto.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] as int;
    final String titulo = json['title'] as String;

    return Producto(
      id: id,
      nombre: titulo,
      precio: id * 100,
    );
  }
}
