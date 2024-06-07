class BookScore {
  BookScore({
    required this.id,
    this.stars,
    this.fiveStarsQuantity,
    this.fiveStarsPorcent,
    this.fourStarsQuantity,
    this.fourStarsPorcent,
    this.threeStarsQuantity,
    this.threeStarsPorcent,
    this.twoStarsQuantity,
    this.twoStarsPorcent,
    this.oneStarsQuantity,
    this.oneStarsPorcent,
  });

  final String id;
  final double? stars;
  final int? fiveStarsQuantity;
  final double? fiveStarsPorcent;
  final int? fourStarsQuantity;
  final double? fourStarsPorcent;
  final int? threeStarsQuantity;
  final double? threeStarsPorcent;
  final int? twoStarsQuantity;
  final double? twoStarsPorcent;
  final int? oneStarsQuantity;
  final double? oneStarsPorcent;

  factory BookScore.fromJson(Map<String, dynamic> json) => BookScore(
        id: json["id"],
        stars: json["stars"].toDouble(),
        fiveStarsQuantity: json["fiveStarsQuantity"],
        fiveStarsPorcent: json["fiveStarsPorcent"].toDouble(),
        fourStarsQuantity: json["fourStarsQuantity"],
        fourStarsPorcent: json["fourStarsPorcent"].toDouble(),
        threeStarsQuantity: json["threeStarsQuantity"],
        threeStarsPorcent: json["threeStarsPorcent"].toDouble(),
        twoStarsQuantity: json["twoStarsQuantity"],
        twoStarsPorcent: json["twoStarsPorcent"].toDouble(),
        oneStarsQuantity: json["oneStarsQuantity"],
        oneStarsPorcent: json["oneStarsPorcent"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stars": stars,
        "fiveStarsQuantity": fiveStarsQuantity,
        "fiveStarsPorcent": fiveStarsPorcent,
        "fourStarsQuantity": fourStarsQuantity,
        "fourStarsPorcent": fourStarsPorcent,
        "threeStarsQuantity": threeStarsQuantity,
        "threeStarsPorcent": threeStarsPorcent,
        "twoStarsQuantity": twoStarsQuantity,
        "twoStarsPorcent": twoStarsPorcent,
        "oneStarsQuantity": oneStarsQuantity,
        "oneStarsPorcent": oneStarsPorcent,
      };

  BookScore copyWith({
    String? id,
    double? stars,
    int? fiveStarsQuantity,
    double? fiveStarsPorcent,
    int? fourStarsQuantity,
    double? fourStarsPorcent,
    int? threeStarsQuantity,
    double? threeStarsPorcent,
    int? twoStarsQuantity,
    double? twoStarsPorcent,
    int? oneStarsQuantity,
    double? oneStarsPorcent,
  }) {
    return BookScore(
      id: id ?? this.id,
      stars: stars ?? this.stars,
      fiveStarsQuantity: fiveStarsQuantity ?? this.fiveStarsQuantity,
      fiveStarsPorcent: fiveStarsPorcent ?? this.fiveStarsPorcent,
      fourStarsQuantity: fourStarsQuantity ?? this.fourStarsQuantity,
      fourStarsPorcent: fourStarsPorcent ?? this.fourStarsPorcent,
      threeStarsQuantity: threeStarsQuantity ?? this.threeStarsQuantity,
      threeStarsPorcent: threeStarsPorcent ?? this.threeStarsPorcent,
      twoStarsQuantity: twoStarsQuantity ?? this.twoStarsQuantity,
      twoStarsPorcent: twoStarsPorcent ?? this.twoStarsPorcent,
      oneStarsQuantity: oneStarsQuantity ?? this.oneStarsQuantity,
      oneStarsPorcent: oneStarsPorcent ?? this.oneStarsPorcent,
    );
  }
}
