class Filter {
  Filter({
    this.filterBy,
    this.priceMin,
    this.priceMax,
  });

  // 0 - Title 1 - Category 2 - Author
  final int? filterBy;
  final double? priceMin;
  final double? priceMax;

  Filter copyWith({
    int? filterBy,
    double? priceMin,
    double? priceMax,
  }) {
    return Filter(
      filterBy: filterBy ?? this.filterBy,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
    );
  }
}
