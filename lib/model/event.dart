class Event {
  final String id;
  final String nombre;
  final String urlImagen;
  final String descripcion;
  final String fecha;
  final String hora;
  final String capacidad;
  final String genteApuntada;
  final String duracion;
  final List<String> medidasSeguridad;

  Event({
    required this.id,
    required this.nombre,
    required this.urlImagen,
    required this.descripcion,
    required this.fecha,
    required this.hora,
    required this.capacidad,
    required this.genteApuntada,
    required this.duracion,
    required this.medidasSeguridad,
  });

  Event.fromJSON(Map<String, dynamic> map)
      : id = map['id'].toString(), // Convertir todos los valores a String
        nombre = map['nombre'].toString(),
        urlImagen = map['urlImagen'].toString(),
        descripcion = map['descripcion'].toString(),
        fecha = map['fecha'].toString(),
        hora = map['hora'].toString(),
        capacidad = map['capacidad'].toString(),
        genteApuntada = map['genteApuntada'].toString(),
        duracion = map['duracion'].toString(),
        medidasSeguridad = map['medidasSeguridad'] != null
            ? List<String>.from(
                map['medidasSeguridad'].map((x) => x.toString()))
            : [];
}
