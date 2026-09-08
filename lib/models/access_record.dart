class AccessRecord {
  final String usuario;
  final DateTime fechaHora;
  final bool exitoso;

  AccessRecord({
    required this.usuario,
    required this.fechaHora,
    required this.exitoso,
  });

  Map<String, dynamic> toJson() => {
    'usuario': usuario,
    'fechaHora': fechaHora.toIso8601String(),
    'resultado': exitoso ? 'AUTORIZADO' : 'RECHAZADO',
  };

  factory AccessRecord.fromJson(Map<String, dynamic> json) {
    final usuario = json['usuario'];
    final fechaHora = json['fechaHora'];
    final resultado = json['resultado'];
    if (usuario is! String ||
        usuario.trim().isEmpty ||
        fechaHora is! String ||
        resultado is! String ||
        (resultado != 'AUTORIZADO' && resultado != 'RECHAZADO')) {
      throw const FormatException('Un registro contiene datos inválidos');
    }

    return AccessRecord(
      usuario: usuario,
      fechaHora: DateTime.parse(fechaHora),
      exitoso: resultado == 'AUTORIZADO',
    );
  }
}
