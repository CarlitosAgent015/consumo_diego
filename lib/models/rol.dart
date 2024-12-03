class Rol {
  final int idRol;

  final String nombre;

  final String descripcion;

  final String estado;

  Rol({
    required this.idRol,

    required this.nombre,

    required this.descripcion,

    required this.estado
  });

  factory Rol.fromJson(Map<String, dynamic> json) {
    try {
      // Verifica si 'id' esta presente y no es null
      if (json['idRol'] == null) {
        throw Exception('El campo idRol es obligatorio y no puede ser null');
      }
    return Rol(
      idRol: json['idRol'],

      nombre: json['nombre'] ?? '',

      descripcion: json['descripcion'] ?? '',

      estado: json['estado'] ?? ''
    );
    } catch (e) {
      throw Exception("Error al parsear rol: $e");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'idRol': idRol,

      'nombre': nombre,

      'descripcion': descripcion,

      'estado': estado
    };
  }
}



