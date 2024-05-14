import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webir_frontend/models/filter.dart';

final filterNotifierProvider =
    StateNotifierProvider<FilterNotifier, Filter>((ref) => FilterNotifier());

class FilterNotifier extends StateNotifier<Filter> {
  FilterNotifier()
      : super(Filter(filterBy: 0, priceMin: 0, priceMax: double.infinity));

  // ignore: use_setters_to_change_properties
  void setMonthIndex(Filter value) => state = value;

  void reset() =>
      state = Filter(filterBy: 0, priceMin: 0, priceMax: double.infinity);
}
