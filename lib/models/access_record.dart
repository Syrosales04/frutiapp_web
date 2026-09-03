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
        'exitoso': exitoso,
      };

  factory AccessRecord.fromJson(Map<String, dynamic> json) {
    return AccessRecord(
      usuario: json['usuario'] ?? '',
      fechaHora: DateTime.parse(json['fechaHora']),
      exitoso: json['exitoso'] ?? false,
    );
  }
}