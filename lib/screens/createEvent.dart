import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}
void _saveEvent() {
  print("Evento guardado"); // TODO: Guardar evento
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtUrl = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtTime = TextEditingController();
  final TextEditingController txtCapacity = TextEditingController();
  final TextEditingController txtDuration = TextEditingController();
  final TextEditingController txtSecurityMeasures = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Crear Evento",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0, // Tamaño de texto más grande
            fontWeight: FontWeight.bold, // Hacer el texto más destacado
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24.0),
            TextField(
              controller: txtName,
              decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder(),),
              inputFormatters: [
                LengthLimitingTextInputFormatter(35),
              ],
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtUrl,
              decoration: const InputDecoration(labelText: 'URL de imagen', border: OutlineInputBorder(),),
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtDescription,
              decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder(),),
              maxLines: 2,
              inputFormatters: [
                LengthLimitingTextInputFormatter(80),
              ],
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtDate,
              decoration: const InputDecoration(labelText: 'Fecha', border: OutlineInputBorder(),),
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtTime,
              decoration: const InputDecoration(labelText: 'Hora', border: OutlineInputBorder(),),
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtCapacity,
              decoration: const InputDecoration(labelText: 'Capacidad', border: OutlineInputBorder(),),
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtDuration,
              decoration: const InputDecoration(labelText: 'Duración', border: OutlineInputBorder(),),
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtSecurityMeasures,
              decoration: const InputDecoration(hintText: 'Medidas de seguridad', border: OutlineInputBorder(),),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: _saveEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}


