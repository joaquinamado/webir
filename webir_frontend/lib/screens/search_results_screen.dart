import 'package:flutter/material.dart';
import 'package:webir_frontend/models/book.dart';
import 'package:webir_frontend/screens/widgets/book_card.dart';
import 'package:webir_frontend/widgets/appbar.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);
  static const String path = '/search-results';

  @override
  createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final List<Book> books = [
    Book(
      id: '1',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      price: 9.99,
    ),
    Book(
      id: '2',
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      price: 9.99,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BSAppbar(),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 250),
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return BookCard(book: books[index]);
            },
          ),
        ),
      ),
    );
  }
}
