import 'package:flutter/material.dart';
import 'package:webir_frontend/models/book.dart';

class BookInfo extends StatefulWidget {
  const BookInfo({Key? key, required this.book}) : super(key: key);
  static const String path = '/book-info';
  final Book book;

  @override
  createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.book.title ?? ''),
            Text(widget.book.author ?? ''),
            Text(widget.book.price.toString()),
          ],
        ),
      ),
    );
  }
}
