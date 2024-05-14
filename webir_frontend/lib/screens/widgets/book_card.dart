import 'package:flutter/material.dart';
import 'package:webir_frontend/models/book.dart';
import 'package:webir_frontend/screens/book_info_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BookInfo(book: book)));
      },
      child: Card(
        child: ListTile(
          title: Text(book.title ?? ''),
          subtitle: Text(book.author ?? ''),
          trailing: Text(book.price.toString()),
        ),
      ),
    );
  }
}
