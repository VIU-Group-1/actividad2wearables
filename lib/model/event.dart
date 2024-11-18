import 'package:actividad2wearables/model/rating.dart';

class Event {
  final String id;
  final String name;
  final String urlImage;
  final String description;
  final String date;
  final String time;
  final String capacity;
  final String actualParticipants;
  final String duration;
  final List<String> securityMeasures;
  final Rating rating;

  Event({
    required this.id,
    required this.name,
    required this.urlImage,
    required this.description,
    required this.date,
    required this.time,
    required this.capacity,
    required this.actualParticipants,
    required this.duration,
    required this.securityMeasures,
    required this.rating,
  });

  Event.fromJSON(Map<String, dynamic> map)
      : id = map['id'].toString(),
        name = map['nombre'].toString(),
        urlImage = map['urlImagen'].toString(),
        description = map['descripcion'].toString(),
        date = map['fecha'].toString(),
        time = map['hora'].toString(),
        capacity = map['capacidad'].toString(),
        actualParticipants = map['genteApuntada'].toString(),
        duration = map['duracion'].toString(),
        securityMeasures = map['medidasSeguridad'] != null
            ? List<String>.from(
                map['medidasSeguridad'].map((x) => x.toString()))
            : [],
        rating = Rating.fromJSON(map['valoracion']);
}
