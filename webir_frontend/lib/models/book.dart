import 'package:webir_frontend/models/book_score.dart';

class Book {
  Book({
    required this.id,
    this.title,
    this.author,
    this.description,
    this.price,
    this.score,
    this.image,
    this.editorial,
    this.fecha,
    this.pages,
    this.language,
    this.subtitle,
  });

  final String id;
  final String? title;
  final String? author;
  final String? description;
  final double? price;
  final String? image;
  final String? subtitle;
  final String? editorial;
  final String? fecha;
  final int? pages;
  final String? language;
  final BookScore? score;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["isbn"],
        title: json["titulo"],
        subtitle: json["subtitulo"],
        image: json["imagen"],
        editorial: json["editorial"],
        fecha: json["fecha_publicacion"],
        pages: json["paginas"],
        language: json["idioma"],
        author: json["autor"],
        description: json["descripcion"],
        price: json["precio"] != null
            ? double.parse(json["precio"] as String)
            : null,
        score: json["score"] != null ? BookScore.fromJson(json["score"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "isbn": id,
        "title": title,
        "author": author,
        "description": description,
        "price": price,
        "score": score?.toJson(),
        "image": image,
        "editorial": editorial,
        "fecha": fecha,
        "pages": pages,
        "language": language,
        "subtitle": subtitle,
      };

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    double? price,
    BookScore? score,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      price: price ?? this.price,
      score: score ?? this.score,
    );
  }
}
