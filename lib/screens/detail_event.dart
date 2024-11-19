import 'package:flutter/material.dart';
import '../model/event.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailEvent extends StatelessWidget {
  final Event event;

  const DetailEvent({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Información del evento",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del evento
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // Imagen del evento
            if (event.urlImage.isNotEmpty)
              Center(
                child: Image.network(
                  event.urlImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16.0),

            // Descripción del evento
            Text(
              event.description,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),

            // Fecha y hora
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.deepPurple),
                const SizedBox(width: 8.0),
                Text(
                  '${event.date} a las ${event.time}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Capacidad
            Row(
              children: [
                const Icon(Icons.people, color: Colors.deepPurple),
                const SizedBox(width: 8.0),
                Text(
                  'Capacidad: ${event.capacity} personas',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Nº de personas suscritas al evento
            Row(
              children: [
                const Icon(Icons.how_to_reg, color: Colors.deepPurple),
                const SizedBox(width: 8.0),
                Text(
                  'Participantes: ${event.actualParticipants} personas',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Duración
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.deepPurple),
                const SizedBox(width: 8.0),
                Text(
                  'Duración: ${event.duration} horas',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Medidas de seguridad
            if (event.securityMeasures.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medidas de Seguridad:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ...event.securityMeasures.map((measure) {
                    return Row(
                      children: [
                        const Icon(Icons.check, color: Colors.green),
                        const SizedBox(width: 8.0),
                        Text(measure),
                      ],
                    );
                  }),
                ],
              ),
            const SizedBox(height: 16.0),
            if (event.rated)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Valoración del evento:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 8.0,
                ),
                RatingBarIndicator(
                  rating: event.rating.rating.toDouble(),
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 30.0,
                  direction: Axis.horizontal,
                ),
                const SizedBox(height: 8.0),
                Text(
                  event.rating.text,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    const Text(
                      'Volvere a asistir: ',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(event.rating.wouldAttendAgain
                        ? (Icons.check)
                        : (Icons.close))
                  ],
                )
              ])
          ],
        ),
      ),
    );
  }
}
