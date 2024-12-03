import 'package:flutter/material.dart';

class SectionModal extends StatelessWidget {
  final String title;

  SectionModal({required this.title});

  Widget _buildContent() {
    switch (title) {
      case 'Informacion del desarrollador':
        return const Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/fabri.jpeg'),
            ),
            Text('Nombre: Fabio Andrés Ochoa Díaz'),
            Text('Teléfono: 3233373293'),
            Text('Correo: fabiochoa2007@gmail.com'),
          ],
        );
      default:
        return const Text('Información no disponible.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildContent(),
        ],
      ),
    );
  }
}
