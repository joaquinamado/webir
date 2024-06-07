import 'package:webir_frontend/models/book_score.dart';

class Book {
  Book({
    required this.id,
    this.title,
    this.author,
    this.description,
    this.price,
    this.score,
  });

  final String id;
  final String? title;
  final String? author;
  final String? description;
  final double? price;
  final BookScore? score;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["isbn"],
        title: json["title"],
        author: json["author"],
        description: json["description"],
        price: json["price"].toDouble(),
        score: json["score"] != null ? BookScore.fromJson(json["score"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "isbn": id,
        "title": title,
        "author": author,
        "description": description,
        "price": price,
        "score": score?.toJson(),
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
