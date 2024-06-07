import 'package:dio/dio.dart';

Future<void> getBooks(String book) async {
  Dio dio = Dio();
  dio.options.baseUrl = 'http://127.0.0.1:8000/';
  final response = await dio.get('/books/', queryParameters: {'book': book});
  if (response.statusCode == 200) {
    print(response.data);
  } else {
    throw Exception('Failed to load books ${response.statusCode}');
  }
}
