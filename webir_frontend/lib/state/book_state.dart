import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webir_frontend/models/book.dart';

final bookNotifierProvider =
    StateNotifierProvider<BookNotifier, List<Book>?>((ref) => BookNotifier());

class BookNotifier extends StateNotifier<List<Book>?> {
  BookNotifier() : super(null);

  // ignore: use_setters_to_change_properties
  void setBooks(List<Book>? value) => state = value;

  void reset() => state = null;
}
