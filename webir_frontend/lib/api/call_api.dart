import 'package:dio/dio.dart';
import 'package:webir_frontend/models/book.dart';

Future<List<Book>> getBooks(String book) async {
  Dio dio = Dio();
  dio.options.baseUrl = 'http://127.0.0.1:8000/';
  try {
    final response = await dio.get('/books', queryParameters: {'book': book});
    if (response.statusCode == 200) {
      List<Book> books = [];
      response.data.forEach((element) {
        print('Element $element');
        books.add(Book.fromJson(element));
      });
      return books;
    } else {
      throw Exception('Failed to load books ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error aca: $e');
    return [];
  }
}
