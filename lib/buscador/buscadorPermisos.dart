import 'package:flutter/material.dart';
import '../services/permiso_service.dart';

class BuscadorPermisos extends StatefulWidget {
  @override
  _BuscadorPermisosState createState() => _BuscadorPermisosState();
}

class _BuscadorPermisosState extends State<BuscadorPermisos> {
  final PermisoService _permisoService = PermisoService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _todosPermisos = [];
  List<Map<String, dynamic>> _resultados = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarPermisos();
  }

  void _cargarPermisos() async {
    setState(() => _isLoading = true);
    try {
      final permisos = await _permisoService.obtenerTodosPermisos();
      setState(() {
        _todosPermisos = permisos;
        _resultados = permisos; // Inicialmente, todos los permisos se muestran
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar permisos: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filtrarPermisos(String nombre) {
    if (nombre.isEmpty) {
      setState(() => _resultados = _todosPermisos);
    } else {
      final resultadosFiltrados = _todosPermisos
          .where((permiso) => permiso['nombre']
              .toString()
              .toLowerCase()
              .contains(nombre.toLowerCase()))
          .toList();
      setState(() => _resultados = resultadosFiltrados);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Permisos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por nombre',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _filtrarPermisos, // Llama a filtrar mientras escribe
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: _resultados.isEmpty
                        ? Center(child: Text('No hay resultados'))
                        : ListView.builder(
                            itemCount: _resultados.length,
                            itemBuilder: (context, index) {
                              final permiso = _resultados[index];
                              return ListTile(
                                title: Text(permiso['nombre'] ?? 'Sin nombre'),
                                subtitle: Text('ID: ${permiso['_id']}'),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
