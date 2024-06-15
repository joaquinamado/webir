import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webir_frontend/models/filter.dart';

final filterNotifierProvider =
    StateNotifierProvider<FilterNotifier, Filter>((ref) => FilterNotifier());

class FilterNotifier extends StateNotifier<Filter> {
  FilterNotifier()
      : super(Filter(
          selectedCategory: null,
          selectedAuthor: null,
          priceMin: 0,
          priceMax: double.infinity,
          fechaFin: null,
          fechaInicio: null,
        ));

  // ignore: use_setters_to_change_properties
  void setMonthIndex(Filter value) => state = value;

  void reset() => state = Filter(
        selectedAuthor: null,
        selectedCategory: null,
        priceMin: 0,
        priceMax: double.infinity,
        fechaInicio: null,
        fechaFin: null,
      );
}
