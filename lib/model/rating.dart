class Rating {
  final String text;
  final bool wouldAttendAgain;
  final double rating;

  Rating({
    required this.text,
    required this.wouldAttendAgain,
    required this.rating
  });

  Rating.fromJSON(Map<String, dynamic> map)
      : text = map['textoValoracion'].toString(),
        wouldAttendAgain = map['volverAsistir'],
        rating = map['estrellas'].toDouble();

  Map<String, dynamic> toJson() {
    return {
      'textoValoracion': text,
      'volverAsistir': wouldAttendAgain,
      'estrellas': rating,
    };
  }
}
