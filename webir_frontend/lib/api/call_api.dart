import 'package:dio/dio.dart';
import 'package:webir_frontend/models/category.dart';
import 'package:webir_frontend/models/book.dart';

Future<List<Book>> getBooks(
    String book,
    String autor,
    String categoria,
    String precioMin,
    String precioMax,
    String fechaInicio,
    String fechaFin) async {
  print(
      'Data Enviada: $book, $autor, $categoria, $precioMin, $precioMax, $fechaInicio, $fechaFin');
  Dio dio = Dio();
  dio.options.baseUrl = 'http://127.0.0.1:8000/';
  try {
    final response = await dio.get('/books', queryParameters: {
      'book': book,
      'autor': autor,
      'categoria': categoria,
      'precioMin': precioMin,
      'precioMax': precioMax,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin
    });
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

Future<List<String>> getAuthors() async {
  Dio dio = Dio();
  dio.options.baseUrl = 'http://127.0.0.1:8000/';
  try {
    final response = await dio.get('/authors');
    if (response.statusCode == 200) {
      List<String> authors = [];
      response.data.forEach((element) {
        authors.add(element);
      });
      return authors;
    } else {
      throw Exception('Failed to load authors ${response.statusCode}');
    }
  } catch (e) {
    print('Error aca: $e');
    return [];
  }
}
