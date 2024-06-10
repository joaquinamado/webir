import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webir_frontend/models/book.dart';
import 'package:webir_frontend/models/book_score.dart';
import 'package:webir_frontend/screens/widgets/book_card.dart';
import 'package:webir_frontend/state/book_state.dart';
import 'package:webir_frontend/state/filter_state.dart';
import 'package:webir_frontend/widgets/appbar.dart';

class SearchResults extends ConsumerStatefulWidget {
  const SearchResults({Key? key}) : super(key: key);
  static const String path = '/search-results';

  @override
  ConsumerState createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<SearchResults> {
  @override
  Widget build(BuildContext context) {
    final List<Book>? books = ref.watch(bookNotifierProvider);

    if (books == null) {
      return Scaffold(
        appBar: BSAppbar(
          onPressed: () {
            ref.read(bookNotifierProvider.notifier).reset();
            Navigator.pop(context);
          },
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (books.isEmpty) {
      return Scaffold(
        appBar: BSAppbar(
          onPressed: () {
            ref.read(bookNotifierProvider.notifier).reset();
            Navigator.pop(context);
          },
        ),
        body: const Center(
          child: Text('No se encontraron resultados'),
        ),
      );
    }
    return Scaffold(
      appBar: BSAppbar(
        onPressed: () {
          ref.read(bookNotifierProvider.notifier).reset();
          Navigator.pop(context);
        },
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: 800,
                height: 800,
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return BookCard(book: books[index]);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                width: 500,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(children: [
                  const Text('Filtros:',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ref.watch(filterNotifierProvider).filterBy == 0
                      ? const Text('Titulo', style: TextStyle(fontSize: 20))
                      : ref.watch(filterNotifierProvider).filterBy == 1
                          ? const Text('Categoria',
                              style: TextStyle(fontSize: 20))
                          : const Text('Autor', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text(
                      'Precio: \$${ref.watch(filterNotifierProvider).priceMin!.toStringAsFixed(2)} - ${ref.watch(filterNotifierProvider).priceMax == double.infinity ? '∞' : '\$${ref.watch(filterNotifierProvider).priceMax!.toStringAsFixed(2)}'}',
                      style: const TextStyle(fontSize: 20)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
