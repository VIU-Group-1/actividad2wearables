import 'dart:convert';

import 'package:actividad2wearables/screens/profile.dart';
import 'package:actividad2wearables/screens/createEvent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/sp_helper.dart';
import '../model/event.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Event> events = [];
  List<Event> oldEvents = [];

  List<String> favorites = [];
  bool onlyFavorites = false;
  final SpHelper helper = SpHelper();

  @override
  void initState() {
    super.initState();
    _fetchEventos();
    _getFavorites();
  }

  // Obtener eventos
  Future<void> _fetchEventos() async {
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
        if (onlyFavorites) {
          events =
              events.where((event) => favorites.contains(event.id)).toList();
        }
      } else {
        throw Exception("Error al cargar los datos");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error de conexión");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eventos ${onlyFavorites ? 'favoritos' : ''}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0, // Tamaño de texto más grande
            fontWeight: FontWeight.bold, // Hacer el texto más destacado
          ),
        ),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                if (!onlyFavorites) {
                  onlyFavorites = true;
                } else {
                  onlyFavorites = false;
                }
                setState(() {});
              },
              icon: onlyFavorites
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border_outlined),
              color: Colors.white,
              iconSize: 35,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              icon: const Icon(Icons.person),
              color: Colors.white,
              iconSize: 35,
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: _fetchEventos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error ${snapshot.error}'));
            } else if (!snapshot.hasData && events.isEmpty) {
              return Center(
                  child: Text(
                      'No hay eventos ${onlyFavorites ? 'favoritos' : ''}'));
            } else {
              return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12.0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: event.urlImage != null
                              ? AspectRatio(
                                  aspectRatio:
                                      1, // Mantener proporción cuadrada
                                  child: Image.network(
                                    event.urlImage,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.event,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        title: Text(
                          event.name,
                          style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "${event.date} a las ${event.time}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                favorites.contains(event.id)
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                size: 30.0,
                                color: Colors.deepPurple[300],
                              ),
                              onPressed: () {
                                saveFavorites(event.id).then((value) {
                                  String message = value;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        message,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.deepPurple,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                  setState(() {});
                                });
                              },
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 18.0,
                              color: Colors.deepPurple[300],
                            ),
                          ],
                        ),
                        onTap: () {
                          // Agregar lógica para abrir el detalle del evento
                        },
                      ),
                    );
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de creación de eventos
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateEventScreen(null)),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Crear nuevo evento',
      ),
    );
  }

  Future<String> saveFavorites(String id) async {
    bool result = false;
    if (favorites.contains(id)) {
      result = await helper.removeFavorite(id);
    } else {
      result = await helper.addFavorite(id);
    }
    if (result) {
      if (!favorites.contains(id)) {
        favorites.add(id);
        setState(() {});
        return "Guardado exitosamente";
      } else {
        favorites.remove(id);
        setState(() {});
        return "Eliminado exitosamente";
      }
    } else {
      return ('Error al guardar/eliminar en favoritos');
    }
  }

  Future<void> _getFavorites() async {
    List<String> favHp = await helper.getFavIds();
    favorites = favHp;
    setState(() {});
  }
}
