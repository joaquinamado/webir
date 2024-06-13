import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webir_frontend/api/call_api.dart';
import 'package:webir_frontend/constants/colors.dart';
import 'package:webir_frontend/models/book.dart';
import 'package:webir_frontend/models/category.dart';
import 'package:webir_frontend/models/filter.dart';
import 'package:webir_frontend/screens/search_results_screen.dart';
import 'package:webir_frontend/state/book_state.dart';
import 'package:webir_frontend/state/filter_state.dart';
import 'package:webir_frontend/widgets/appbar.dart';
import 'package:webir_frontend/widgets/elevated_button.dart';
import 'package:webir_frontend/widgets/search_button.dart';
import 'package:webir_frontend/widgets/textform_field.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  static const String path = '/';

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController controller = TextEditingController();
  int _selectedFilter = 0;
  double _minPrice = 0;
  double _maxPrice = double.infinity;
  final List<DropdownMenuEntry> _categories = [];

  @override
  void initState() {
    super.initState();
  }

  void _getCategories() {
    getCategories().then((value) {
      int index = 0;
      for (String category in value) {
        _categories.add(DropdownMenuEntry(
          label: category,
          value: index,
        ));
        index++;
      }
      setState(() {});
    }).onError((error, stackTrace) {
      print('Error getting categories: $error');
    });
    print('Cat ${_categories.length}');
  }

  @override
  Widget build(BuildContext context) {
    print('Building home');
    if (_categories.isEmpty) {
      _getCategories();
      return const Scaffold(
        appBar: BSAppbar(onPressed: null),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: const BSAppbar(onPressed: null),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(alignment: Alignment.center, children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Image.asset('../../assets/images/book_cover.jpg',
                    width: 800, height: 800, fit: BoxFit.fitHeight),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BSTextFormField(label: '', controller: controller),
                    const SizedBox(height: 20),
                    BSElevatedButton(
                        label: 'Search',
                        onPressed: () async {
                          if (controller.text.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Please enter a search term'),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'))
                                      ]);
                                });
                            return;
                          }
                          // Perform search
                          _searchBooks(controller.text);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchResults()));
                        }),
                  ],
                ),
              ),
            ]),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(
                    'Filtrar',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DropdownMenu(
                  menuStyle: const MenuStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(BSConstants.tertiaryColor),
                  ),
                  label: const Text('Categorias'),
                  dropdownMenuEntries: _categories,
                ),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(
                    'Autor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(
                    'Precio',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 400,
                  height: 40,
                  child: RangeSlider(
                    values: RangeValues(_minPrice,
                        _maxPrice == double.infinity ? 1000 : _maxPrice),
                    min: 0,
                    max: 1000,
                    activeColor: BSConstants.tertiaryColor,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 400,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Min: \$${_minPrice.toStringAsFixed(2)}'),
                      Text(
                          'Max: ${_maxPrice == double.infinity || _maxPrice == 1000 ? 'Unlimited' : '\$${_maxPrice.toStringAsFixed(2)}'}'),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _searchBooks(String text) async {
    ref.read(filterNotifierProvider.notifier).setMonthIndex(Filter(
        filterBy: _selectedFilter,
        priceMin: _minPrice,
        priceMax: _maxPrice == 1000 ? double.infinity : _maxPrice));
    List<Book> books = await getBooks(text);
    ref.read(bookNotifierProvider.notifier).setBooks(books);
  }
}
