import 'package:actividad2wearables/data/sp_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:actividad2wearables/model/event.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math' as math;
import 'package:actividad2wearables/screens/list.dart';

class RatingEventScreen extends StatefulWidget {
  final Event event;

  const RatingEventScreen({required this.event, super.key});

  @override
  _RatingEventScreenState createState() => _RatingEventScreenState();
}

class _RatingEventScreenState extends State<RatingEventScreen> {
  final SpHelper helper = SpHelper();
  final TextEditingController txtRatingController = TextEditingController();
  bool wouldAttendAgain = false;
  double rating = 0;

  // Valorar
  Future<bool> acceptRating() async {
    print(txtRatingController.text);
    print(rating);
    if (txtRatingController.text.isEmpty ||
        rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos obligatorios'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    print("Valorar");
    return true;
  }

  // No permitir saltos de línea
  void noNewLine(String text, TextEditingController controller) {
    final int lineCount = '\n'.allMatches(text).length + 1;
    if (lineCount > 1) {
      final regEx = RegExp("^.*((\n?.*){0,${1 - 1}})");
      String newString = regEx.stringMatch(text) ?? "";
      controller.value = TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: math.min(newString.length, controller.selection.end)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Valora el evento",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.event.name,
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '¿Qué te ha parecido el evento?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: txtRatingController,
              maxLength: 100,
              maxLines: 3,
                decoration: const InputDecoration(
                    hintText: 'Escribe tu opinión aquí...', border: OutlineInputBorder()),
              onChanged: (text) => noNewLine(text, txtRatingController),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('¿Volverías a asistir a este evento?'),
              value: wouldAttendAgain,
              onChanged: (value) {
                setState(() {
                  wouldAttendAgain = value ?? false;
                });
              },
            ),
            SizedBox(height: 16),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Tu valoración:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        this.rating = rating;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  acceptRating().then((value) {
                    String message = 'Evento valorado correctamente';
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            message,
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.deepPurple,
                          duration: const Duration(seconds: 2),
                        ),
                      ).closed.then((_) { // Espera a que termine el SnackBar
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ListScreen()),
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error al valorar el evento',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }).catchError((error) {
                    // Manejar errores
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Ocurrió un error: $error',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Valorar evento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
