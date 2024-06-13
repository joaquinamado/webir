import 'package:dio/dio.dart';
import 'package:webir_frontend/models/category.dart';
import 'package:webir_frontend/models/book.dart';

Future<List<Book>> getBooks(String book) async {
  Dio dio = Dio();
  dio.options.baseUrl = 'http://127.0.0.1:8000/';
  try {
    final response = await dio.get('/books', queryParameters: {'book': book});
    if (response.statusCode == 200) {
      List<Book> books = [];
      response.data.forEach((element) {
        books.add(Book.fromJson(element));
      });
      return books;
    } else {
      throw Exception('Failed to load books ${response.statusCode}');
    }
  } catch (e) {
    print('Error aca: $e');
    return [];
  }
}

Future<List<String>> getCategories() async {
  Dio dio = Dio();
  dio.options.baseUrl = 'http://127.0.0.1:8000/';
  try {
    final response = await dio.get('/categories');
    if (response.statusCode == 200) {
      List<String> categories = [];
      response.data.forEach((element) {
        categories.add(element);
      });
      return categories;
    } else {
      throw Exception('Failed to load categories ${response.statusCode}');
    }
  } catch (e) {
    print('Error aca: $e');
    return [];
  }
}
