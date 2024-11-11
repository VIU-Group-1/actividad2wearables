import 'package:actividad2wearables/data/sp_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:actividad2wearables/model/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:actividad2wearables/screens/list.dart';

class CreateEventScreen extends StatefulWidget {
  final String? id;
  const CreateEventScreen(this.id, {super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  List<Event> events = [];
  Event? event = null;

  final SpHelper helper = SpHelper();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtUrl = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtTime = TextEditingController();
  final TextEditingController txtCapacity = TextEditingController();
  final TextEditingController txtDuration = TextEditingController();
  final TextEditingController txtSecurityMeasures = TextEditingController();

  // Método para guardar el evento en Json
  Future<void> createEvent(Event event) async {
    final url = Uri.parse('http://10.0.2.2:3000/eventos');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "id": event.id,
          "name": event.name,
          "urlImage": event.urlImage,
          "description": event.description,
          "date": event.date,
          "time": event.time,
          "capacity": event.capacity,
          "actualParticipants": event.actualParticipants,
          "duration": event.duration,
          "securityMeasures": event.securityMeasures,
        }),
      );

      if (response.statusCode == 201) {
        print("Evento creado con éxito en el servidor");
      } else {
        throw Exception("Error al crear el evento en el servidor");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error de conexión al servidor");
    }
  }

  // Método para editar el evento en Json
  Future<void> updateEvent(Event event) async {
    final url = Uri.parse('http://10.0.2.2:3000/eventos/${event.id}');
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "id": event.id,
          "name": event.name,
          "urlImage": event.urlImage,
          "description": event.description,
          "date": event.date,
          "time": event.time,
          "capacity": event.capacity,
          "actualParticipants": event.actualParticipants,
          "duration": event.duration,
          "securityMeasures": event.securityMeasures,
        }),
      );

      if (response.statusCode == 200) {
        print("Evento actualizado con éxito en el servidor");
      } else {
        throw Exception("Error al actualizar el evento en el servidor");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error de conexión al servidor");
    }
  }

  // Método para obtener eventos
  Future<void> _fetchEvents() async {
    // JSON Server URL
    final url = Uri.parse('http://10.0.2.2:3000/eventos');
    try {
      final response = await http.get(url);
      // Comprobar que la respuesta es correcta
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> jsonEvents = json.decode(decodedBody);
        jsonEvents.forEach((event) {
          Event.fromJSON(event);
        });
        events = jsonEvents.map((event) => Event.fromJSON(event)).toList();
        if (widget.id != null) _printEvent();
      } else {
        throw Exception("Error al cargar los datos");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error de conexión");
    }
  }

  // Método para escribir datos de evento a editar
  Future<void> _printEvent() async {
    Event event = events[0];

    for (int i = 0; i < events.length; i++)
    {
        if (events[i].id == widget.id)
        {
            event = events[i];
            this.event = event;
        }
    }
    txtName.text = event.name ?? 'Event';
    txtUrl.text = event.urlImage ?? 'https://img.freepik.com/fotos-premium/diseno-escenario-evento-vacio-maqueta-e-identidad-corporativa-pantallas-blancas_581196-1.jpg';
    txtDescription.text = event.description ?? 'Description';
    txtDate.text = event.date ?? '01/01/2025';
    txtTime.text = event.time ?? '0:00 AM';
    txtCapacity.text = event.capacity ?? '0';
    txtDuration.text = event.duration ?? '0';
    List<String> securityMeasures = [event.securityMeasures[0]];
    for (int i = 1; i < event.securityMeasures.length; i++)
    {
      securityMeasures.add(event.securityMeasures[i].trim().isNotEmpty ? event.securityMeasures[i].trim()[0].toLowerCase() + event.securityMeasures[i].trim().substring(1) : event.securityMeasures[i]);
    }
    txtSecurityMeasures.text = securityMeasures.join(', ');
  }

  // Método para seleccionar la fecha con el DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        txtDate.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Método para seleccionar la hora con el TimePicker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        txtTime.text = picked.format(context);
      });
    }
  }

  // No permitir saltos de línea
  void noNewLine(String text, TextEditingController controller) {
    final int lineCount = '\n'.allMatches(text).length + 1;
    if (lineCount > 1) {
      final regEx = RegExp("^.*((\n?.*){0,${1 - 1}})");
      String newString = regEx.stringMatch(text) ?? "";
      controller.value = TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: math.min(newString.length, controller.selection.end)),
      );
    }
  }

  // Método para comprobar campos rellenos
  Future<bool> checkEvent() async {
    if (txtName.text.isEmpty || txtUrl.text.isEmpty || txtDescription.text.isEmpty || txtDate.text.isEmpty || txtTime.text.isEmpty || txtCapacity.text.isEmpty || txtDuration.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos obligatorios'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (widget.id == null)
    {
      final Event event = Event(
          id: DateTime.now().toString(),
          name: txtName.text,
          urlImage: txtUrl.text,
          description: txtDescription.text,
          date: txtDate.text,
          time: txtTime.text,
          capacity: txtCapacity.text,
          actualParticipants: '0',
          duration: txtDuration.text,
          securityMeasures: txtSecurityMeasures.text.split(',').map((measure) =>
          measure.trim().isNotEmpty? measure.trim()[0].toUpperCase() + measure.trim().substring(1) : measure.trim()).toList());

      createEvent(event);
    }
    else
    {
      final Event event = Event(
          id: widget.id ?? '0',
          name: txtName.text,
          urlImage: txtUrl.text,
          description: txtDescription.text,
          date: txtDate.text,
          time: txtTime.text,
          capacity: txtCapacity.text,
          actualParticipants: this.event?.actualParticipants ?? '0',
          duration: txtDuration.text,
          securityMeasures: txtSecurityMeasures.text.split(',').map((measure) =>
          measure.trim().isNotEmpty? measure.trim()[0].toUpperCase() + measure.trim().substring(1) : measure.trim()).toList());

      updateEvent(event);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.id == null) ? "Crear Evento" : "Editar Evento",
          style: TextStyle(
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
          children: [
            const SizedBox(height: 24.0),
            TextField(
              controller: txtName,
              decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
              inputFormatters: [LengthLimitingTextInputFormatter(35)]
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtUrl,
              decoration: const InputDecoration(labelText: 'URL de imagen', border: OutlineInputBorder()),
              inputFormatters: [LengthLimitingTextInputFormatter(250)]
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtDescription,
              decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
              maxLines: 2,
              inputFormatters: [LengthLimitingTextInputFormatter(115)],
              onChanged: (text) => noNewLine(text, txtDescription),
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtDate,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Fecha', border: OutlineInputBorder()),
              onTap: () => _selectDate(context)
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtTime,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Hora', border: OutlineInputBorder()),
              onTap: () => _selectTime(context)
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtCapacity,
              decoration: const InputDecoration(labelText: 'Capacidad', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)]
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtDuration,
              decoration: const InputDecoration(labelText: 'Duración (horas)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)]
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: txtSecurityMeasures,
              decoration: const InputDecoration(labelText: 'Medidas de seguridad (separadas por ",")', border: OutlineInputBorder()),
              maxLines: 2,
              inputFormatters: [LengthLimitingTextInputFormatter(115)],
              onChanged: (text) => noNewLine(text, txtSecurityMeasures)
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                checkEvent().then((value) {

                  String message = '';
                  if ((widget.id == null)) message = 'Evento creado correctamente';
                  else message = 'Evento editado correctamente';

                  if (value)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            message,
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.deepPurple,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListScreen()),
                      );
                    }

                  setState(() {});
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))
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