import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:consumo_flutter/models/rol.dart';

class RolService {
  static const String baseUrl = "https://nodeapi-4idn.onrender.com/rol";

  // Listar todos los roles
  Future<List<Rol>> getRoles() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> rolesData = jsonDecode(response.body);
      return rolesData
          .map((item) => Rol.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error obteniendo los datos');
    }
  }

  // Registrar un rol
  Future<void> createRol(
      int idRol, String nombre, String descripcion, String estado) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'idRol': idRol,
        'nombre': nombre,
        'descripcion': descripcion,
        'estado': estado
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Rol creado exitosamente');
      await getRoles(); // Actualizar la lista tras una creación exitosa
    } else {
      throw Exception("Error al registrar un rol: ${response.body}");
    }
  }

  // Actualizar un rol
  Future<void> updateRol(
      int idRol, String nombre, String descripcion, String estado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$idRol'), // Asegúrate de que el endpoint sea correcto
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'idRol':
            idRol, // Si el backend no requiere este campo en la actualización, elimínalo
        'nombre': nombre,
        'descripcion': descripcion,
        'estado': estado,
      }),
    );

    if (response.statusCode == 200) {
      print('Rol actualizado exitosamente');
      await getRoles(); // Actualizar la lista tras una actualización exitosa
    } else {
      throw Exception("Error al actualizar el rol: ${response.body}");
    }
  }

  // Eliminar un rol
  Future<void> deleteRol(int idRol) async {
    final response = await http.delete(Uri.parse('$baseUrl/$idRol'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Rol eliminado exitosamente');
    } else {
      throw Exception("Error al eliminar rol: ${response.body}");
    }
  }
}