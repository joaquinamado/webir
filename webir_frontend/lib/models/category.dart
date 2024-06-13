class Category {
  Category({
    required this.name,
  });

  final String? name;

  factory Category.fromJson(String json) => Category(
        name: json,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };

  Category copyWith({
    String? name,
  }) {
    return Category(
      name: name ?? this.name,
    );
  }
}
