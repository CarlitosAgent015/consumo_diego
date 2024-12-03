class Permiso {
  final int idPermiso;

  final String nombre;

  final String descripcion;

  final String estado;

  Permiso({
    required this.idPermiso,

    required this.nombre,

    required this.descripcion,

    required this.estado
  });

  factory Permiso.fromJson(Map<String, dynamic> json) {
    try {
      if (json['idPermiso'] == null) {
        throw Exception('El campo idPermiso es obligatorio y no puede ser null');
      }
    return Permiso(
      idPermiso: json['idPermiso'],

      nombre: json['nombre'] ?? '',

      descripcion: json['descripcion'] ?? '',

      estado: json['estado'] ?? ''
      );
    } catch (e) {
      throw Exception("Error al parsear Permiso: $e");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'idPermiso': idPermiso,

      'nombre' : nombre,

      'descripcion': descripcion,

      'estado' : estado
    };
  }
}