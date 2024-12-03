import 'package:flutter/material.dart';
import './section_modal.dart';

class ExtrasScreen extends StatelessWidget {
  final List<Map<String, dynamic>> sections = [
    {'title': 'Informacion del desarrollador', 'icon': Icons.person},
  ];

  void _showCenteredDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Ajusta el ancho de la modal
            height: MediaQuery.of(context).size.height *
                0.5, // Ajusta la altura de la modal
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child:
                  SectionModal(title: title), // Pasa el título a SectionModal
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Hoja de Vida')),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return ListTile(
            leading: Icon(section['icon']),
            title: Text(section['title']),
            onTap: () {
              // Al hacer tap en "Información del desarrollador", mostramos los datos personales
              _showCenteredDialog(context, 'Informacion del desarrollador');
            },
          );
        },
      ),
    );
  }
}
