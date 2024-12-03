import 'package:flutter/material.dart';
import '../services/rol_service.dart';
import '../models/rol.dart';

class ListRolScreen  extends StatefulWidget {

  ListRolScreen({super.key});

  @override
  State<ListRolScreen> createState() =>
  _ListRolScreenState();
}

class _ListRolScreenState extends State<ListRolScreen> {
  final RolService rolService = RolService();

  List<Rol> roles = [];

  @override
  void initState() { //Cargar al inicio los roles
  super.initState();
  _loadRoles(); //Cargar informacion de los roles
  }

  Future<void> _loadRoles() async {
    try {
      final fetchedRoles = await rolService.getRoles();
      setState(() {
        roles = fetchedRoles;
      });
    } catch (e) {
      print("Error cargando roles $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los roles. Intenta nuevamente.'))
      );
    }
  }

  void _registerRol(int idRol, String nombre, String descripcion, String estado) async {
    // Expresiones regulares para las validaciones
    final RegExp idRolRegEx = RegExp(r'^\d+$'); // Solo números para el idRol
    final RegExp nombreRegEx =
        RegExp(r'^[a-zA-Z0-9\s]+$'); // Letras, números y espacios
    final RegExp descripcionRegEx = RegExp(
        r'^[a-zA-Z0-9\s\.,;]+$'); // Letras, números y caracteres especiales
    final RegExp estadoRegEx = RegExp(r'^(activo|inactivo)$',
        caseSensitive: false); // Estado puede ser 'activo' o 'inactivo'

    // Validación de idRol
    if (!idRolRegEx.hasMatch(idRol.toString())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El ID de rol debe ser un número válido')),
      );
      return;
    }

    // Validación de nombre
    if (nombre.isEmpty || !nombreRegEx.hasMatch(nombre)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('El nombre debe ser válido (letras, números y espacios)')),
      );
      return;
    }

    // Validación de descripción
    if (descripcion.isEmpty || !descripcionRegEx.hasMatch(descripcion)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'La descripción debe ser válida (letras, números y algunos caracteres como .,;)')),
      );
      return;
    }

    // Validación de estado
    if (estado.isEmpty || !estadoRegEx.hasMatch(estado)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El estado debe ser "activo" o "inactivo"')),
      );
      return;
    }
    try {
      await rolService.createRol(idRol, nombre, descripcion, estado);
      await _loadRoles(); // Refrescar la lista de roles
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rol creado exitosamente!'),)
        );
        Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hubo un problema al crear el rol $e'))
      );
    }
  }

  void _editRol(int idRol, String nombre, String descripcion, estado) async {
    // Expresiones regulares para las validaciones
    final RegExp nombreRegEx =
        RegExp(r'^[a-zA-Z0-9\s]+$'); // Letras, números y espacios
    final RegExp descripcionRegEx = RegExp(
        r'^[a-zA-Z0-9\s\.,;]+$'); // Letras, números y caracteres especiales
    final RegExp estadoRegEx = RegExp(r'^(activo|inactivo)$',
        caseSensitive: false); // Estado puede ser 'activo' o 'inactivo'

    // Validación de nombre
    if (nombre.isEmpty || !nombreRegEx.hasMatch(nombre)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('El nombre debe ser válido (letras, números y espacios)')),
      );
      return;
    }

    // Validación de descripción
    if (descripcion.isEmpty || !descripcionRegEx.hasMatch(descripcion)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'La descripción debe ser válida (letras, números y algunos caracteres como .,;)')),
      );
      return;
    }

    // Validación de estado
    if (estado.isEmpty || !estadoRegEx.hasMatch(estado)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El estado debe ser "activo" o "inactivo"')),
      );
      return;
    }

    try {
      await rolService.updateRol(idRol, nombre, descripcion, estado);
      await _loadRoles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rol actualizado exitosamente'))
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hubo un problema al actualizar el rol $e'),)
        );
    }
  }

  void showRegisterModalRol() {
    final TextEditingController _idRolController = TextEditingController();
    final TextEditingController _nombreController = TextEditingController();
    final TextEditingController _descripcionController = TextEditingController();
    final TextEditingController _estadoController = TextEditingController();

    showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Registrar rol'),
        content: SingleChildScrollView(child: Column(
          children: [
            TextFormField(controller: _idRolController,
            decoration: const InputDecoration(hintText: 'ID Rol',
            labelText: 'Enter Id Rol',
            icon:Icon(Icons.numbers_rounded)),
            ),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(hintText: 'Nombre',
              labelText: 'Enter nombre',
              icon:Icon(Icons.person_pin_circle)),
            ),
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(hintText: 'Descripcion',
              labelText: 'Enter descripcion',
              icon:Icon(Icons.description_rounded)),
            ),
            TextFormField(
              controller: _estadoController,
              decoration: const InputDecoration(hintText: 'Estado',
              labelText: 'Enter estado',
              icon:Icon(Icons.description_rounded)),
            )
          ],
        )),
        actions: [
          ElevatedButton(onPressed: () {
            final _idRol = int.parse(_idRolController.text.trim());
            final _nombre = _nombreController.text.trim();
            final _descripcion = _descripcionController.text.trim();
            final _estado = _estadoController.text.trim();

            print('$_idRol $_nombre $_descripcion $_estado');
            _registerRol(_idRol, _nombre, _descripcion, _estado);
          }, child: const Text('Registrar')),

          TextButton(onPressed: () {
            Navigator.of(context).pop(); // Cerrar la modal
          }, child: Text('Cancelar'))
        ],
      );
    });
  }

  void showEditModalRol(int idRol, String nombre, String descripcion, String estado) {
    final TextEditingController _idRolController = TextEditingController();
    final TextEditingController _nombreController = TextEditingController();
    final TextEditingController _descripcionController = TextEditingController();
    final TextEditingController _estadoController = TextEditingController();

    //Asignar colores a las cajas de texto
    _idRolController.text = idRol.toString();
    _nombreController.text = nombre;
    _descripcionController.text = descripcion;
    _estadoController.text = estado;

    showDialog(
    context: context,
    builder: (context) {
      return  AlertDialog(
        title:  Text('Editar rol'),
        content: SingleChildScrollView(child: Column (
          children: [
            TextFormField(controller: _idRolController,
            decoration: const InputDecoration(hintText:
            'idRol',
            labelText: 'Enter ID rol',
            icon:Icon(Icons.numbers_rounded)),),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(hintText:
              'Nombre',
              labelText: 'Enter nombre',
              icon:Icon(Icons.colorize_outlined)),),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(hintText:
                'Descripcion',
                labelText: 'Enter descripcion',
                icon:Icon(Icons.model_training_outlined)),),
                TextFormField(
                  controller: _estadoController,
                  decoration: const InputDecoration(hintText:
                  'Estado',
                  labelText: 'Enter estado',
                  icon:Icon(Icons.sunny)),)
          ],
        ),),
        actions: [
          ElevatedButton(onPressed: () {
            final _idRol = int.parse(_idRolController.text.trim());
            final _nombre = _nombreController.text.trim();
            final _descripcion = _descripcionController.text.trim();
            final _estado = _estadoController.text.trim();

            print('$_idRol $_nombre $_descripcion $_estado');
            _editRol(_idRol, _nombre, _descripcion, _estado);

          }, child: Text('Guardar')),

          TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text('Cancelar'))
        ],
      );
    });
  }

  void showDeleteModalRol(int idRol, String nombre, String descripcion, String estado) async {
    final confirmDelete = await showDialog<bool>(context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Eliminar el Rol'),
        content: Text('Tu enserio quieres eliminar el Rol?'),
        actions: [
          TextButton.icon(onPressed: () {
            Navigator.of(context).pop(false);
          }, label: Text('Cancel',
          style: TextStyle(color:Colors.lightBlue)),
          icon: Icon(Icons.cancel_rounded),
          ),

          TextButton.icon(onPressed:() {
            Navigator.of(context).pop(true);
          }, label: Text('Confirmar'),
          icon: Icon(Icons.confirmation_num_rounded),
          style:TextButton.styleFrom(backgroundColor: const Color.fromARGB(255, 213, 215, 216)))
        ],
      );
    },
    );
    if(confirmDelete == true) {
      await rolService.deleteRol(idRol);
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rol eliminado exitosamente'))
      );
      _loadRoles();
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Lista de Roles"),
    ),
    body: FutureBuilder<List<Rol>>(
      future: rolService.getRoles(),  // Suponiendo que tienes un método para obtener roles
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ocurrió un error al cargar los roles'));
        } else {
          final roles = snapshot.data ?? [];

          // Controlador del buscador
          final TextEditingController searchController = TextEditingController();

          // Lista filtrada de roles
          List<Rol> rolesFiltrados = roles;

          void actualizarBusqueda(String query) {
            rolesFiltrados = roles
                .where((rol) => rol.nombre.toLowerCase().contains(query.toLowerCase()))
                .toList();
          }

          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  // Buscador
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: "Buscar rol por nombre",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (query) {
                        setState(() {
                          actualizarBusqueda(query);
                        });
                      },
                    ),
                  ),
                  // Lista de roles
                  Expanded(
                    child: ListView.builder(
                      itemCount: rolesFiltrados.length,
                      itemBuilder: (context, index) {
                        final rol = rolesFiltrados[index];
                        return ListTile(
                          title: Text(rol.idRol.toString()),
                          subtitle: Text(
                              '${rol.nombre} ${rol.descripcion} ${rol.estado}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showEditModalRol(
                                      rol.idRol,
                                      rol.nombre,
                                      rol.descripcion,
                                      rol.estado);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              const SizedBox(width: 30),
                              IconButton(
                                onPressed: () {
                                  showDeleteModalRol(rol.idRol, rol.nombre, rol.descripcion, rol.estado);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    ),
    floatingActionButton: FloatingActionButton(
      tooltip: 'Agregar nuevo rol',
      child: const Icon(Icons.add),
      onPressed: showRegisterModalRol,
    ),
  );
}
}