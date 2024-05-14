class Book {
  Book({
    required this.id,
    this.title,
    this.author,
    this.description,
    this.price,
    this.isbn,
  });

  final String id;
  final String? title;
  final String? author;
  final String? description;
  final double? price;
  final List<String>? isbn;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        description: json["description"],
        price: json["price"].toDouble(),
        isbn: List<String>.from(json["isbn"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "description": description,
        "price": price,
        "isbn": List<dynamic>.from(isbn!.map((x) => x)),
      };

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    double? price,
    List<String>? isbn,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      price: price ?? this.price,
      isbn: isbn ?? this.isbn,
    );
  }
}
