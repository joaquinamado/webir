class Filter {
  Filter({
    this.selectedAuthor,
    this.selectedCategory,
    this.priceMin,
    this.priceMax,
    this.fechaInicio,
    this.fechaFin,
  });

  final String? selectedAuthor;
  final String? selectedCategory;
  final String? fechaInicio;
  final String? fechaFin;
  final double? priceMin;
  final double? priceMax;

  Filter copyWith({
    String? selectedAuthor,
    String? selectedCategory,
    double? priceMin,
    double? priceMax,
    String? fechaInicio,
    String? fechaFin,
  }) {
    return Filter(
      selectedAuthor: selectedAuthor ?? this.selectedAuthor,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
    );
  }
}
