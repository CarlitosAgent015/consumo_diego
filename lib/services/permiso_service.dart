import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:consumo_flutter/models/permiso.dart';

class PermisoService {
  static const String baseUrl = "https://nodeapi-4idn.onrender.com/permiso";

  //Listar todos los permisos
  Future<List<Permiso>> getPermisos() async {
    final response = await http.get(Uri.parse(baseUrl));
    
    if (response.statusCode == 200) {
      final List<dynamic> permisosData = jsonDecode(response.body);
      return permisosData.map((item) => Permiso.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error obteniendo los datos');
    }
  }

  // Registrar un permiso
  Future<void> createPermiso(
    int idPermiso, String nombre, String descripcion, String estado) async {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'idPermiso': idPermiso,
          'nombre': nombre,
          'descripcion': descripcion,
          'estado': estado
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Permiso creado exitosamente');
        await getPermisos();
      } else {
        throw Exception("Error al registrar el permiso: ${response.body}");
      }
    }

    // Actualizar un permiso
    Future<void> updatePermiso(
      int idPermiso, String nombre, String descripcion, String estado) async {
        final response = await http.put(
          Uri.parse('$baseUrl/$idPermiso'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'idPermiso': idPermiso,
            'nombre': nombre,
            'descripcion': descripcion,
            'estado': estado
          })
        );

        if (response.statusCode == 200) {
          print('Permiso actualizado exitosamente');
          await getPermisos();
        } else {
          throw Exception("Error al actualizar el permiso: ${response.body}");
        }
      }

      // Elimianr un permiso
      Future<void> deletePermiso(int idPermiso) async {
        final response = await http.delete(Uri.parse('$baseUrl/$idPermiso'));

        if (response.statusCode == 200 || response.statusCode == 204) {
          print('Permiso eliminado exitosamente');
        } else {
          throw Exception("Error al eliminar el permiso: ${response.body} ");
        }
      }

      Future<List<Map<String, dynamic>>> obtenerTodosPermisos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> permisosJson = json.decode(response.body);
      return permisosJson
          .cast<Map<String, dynamic>>(); // Convertimos a lista de mapas
    } else {
      throw Exception('Error al obtener permisos');
    }
  }
}