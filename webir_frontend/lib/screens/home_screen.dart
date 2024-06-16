import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webir_frontend/api/call_api.dart';
import 'package:webir_frontend/constants/colors.dart';
import 'package:webir_frontend/models/book.dart';
import 'package:webir_frontend/models/filter.dart';
import 'package:webir_frontend/screens/search_results_screen.dart';
import 'package:webir_frontend/state/book_state.dart';
import 'package:webir_frontend/state/filter_state.dart';
import 'package:webir_frontend/widgets/appbar.dart';
import 'package:webir_frontend/widgets/elevated_button.dart';
import 'package:webir_frontend/widgets/textform_field.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  static const String path = '/';

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final TextEditingController controller = TextEditingController();
  double _minPrice = 0;
  double _maxPrice = double.infinity;
  String? _selectedCategory;
  String? _selectedAuthor;
  String? _fechaInicio;
  String? _fechaFin;
  String? _priceMinError;
  String? _priceMaxError;
  final List<DropdownMenuEntry> _categories = [];
  final List<DropdownMenuEntry> _authors = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
    _getAuthors();
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
  }

  void _getAuthors() {
    getAuthors().then((value) {
      int index = 0;
      for (String author in value) {
        _authors.add(DropdownMenuEntry(
          label: author,
          value: index,
        ));
        index++;
      }
      setState(() {});
    }).onError((error, stackTrace) {
      print('Error getting authors: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty || _authors.isEmpty) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: [
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
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      ref.read(filterNotifierProvider.notifier).reset();
                      setState(() {
                        _selectedCategory = null;
                        _selectedAuthor = null;
                        _minPrice = 0;
                        _maxPrice = double.infinity;
                        _fechaInicio = null;
                        _fechaFin = null;
                      });
                    },
                  ),
                ]),
                _buildCategoriasAndAutor(),
                const SizedBox(width: 10),
                _buildPrecio(),
                const SizedBox(height: 10),
                _buildFechas(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriasAndAutor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DropdownMenu(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.grey[200]),
            fixedSize: const WidgetStatePropertyAll(Size(200, 300)),
          ),
          label: const Text('Categorias'),
          dropdownMenuEntries: _categories,
          initialSelection: _selectedCategory == null
              ? null
              : _categories
                  .indexWhere((element) => element.label == _selectedCategory),
          onSelected: (index) {
            setState(() {
              _selectedCategory = _categories[index as int].label;
            });
          },
        ),
        const SizedBox(height: 10),
        DropdownMenu(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.grey[200]),
            fixedSize: const WidgetStatePropertyAll(Size(200, 300)),
          ),
          label: const Text('Autores'),
          initialSelection: _selectedAuthor == null
              ? null
              : _authors
                  .indexWhere((element) => element.label == _selectedAuthor),
          dropdownMenuEntries: _authors,
          onSelected: (index) {
            setState(() {
              _selectedAuthor = _authors[index as int].label;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPrecio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Min',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        if (value.contains(RegExp(r'[a-zA-Z]')) ||
                            double.parse(value) > _maxPrice) {
                          _priceMinError =
                              'El precio mínimo debe ser un número, menor al precio máximo';
                        } else {
                          _priceMinError = null;
                          _minPrice = double.parse(value);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Max',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        if (value.contains(RegExp(r'[a-zA-Z]')) ||
                            double.parse(value) < _minPrice) {
                          _priceMaxError =
                              'El precio maximo debe ser un número menor al precio mínimo';
                        } else {
                          _priceMaxError = null;
                        }
                      });
                    },
                  ),
                ),
              ],
            )),
        const SizedBox(height: 10),
        Text(_priceMinError ?? '', style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 10),
        Text(_priceMaxError ?? '', style: const TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _buildFechas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 400,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text('Fecha de publicación desde:'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? fechaInicio = await showDialog(
                          context: context,
                          builder: (context) {
                            return DatePickerDialog(
                                firstDate: DateTime(1000),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 1)));
                          });
                      if (fechaInicio != null) {
                        setState(() {
                          DateFormat formatter = DateFormat('yyyy-MM-dd');
                          _fechaInicio = formatter.format(fechaInicio);
                        });
                      }
                    },
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Text('Fecha Inicio: ${_fechaInicio ?? ''}')),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Text('Fecha de publicación hasta:'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? fechaFin = await showDialog(
                          context: context,
                          builder: (context) {
                            return DatePickerDialog(
                                firstDate: DateTime(1000),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 1)));
                          });
                      if (fechaFin != null) {
                        setState(() {
                          DateFormat formatter = DateFormat('yyyy-MM-dd');
                          _fechaFin = formatter.format(fechaFin);
                        });
                      }
                    },
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Text('Fecha Fin: ${_fechaFin ?? ''}'),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _searchBooks(String text) async {
    ref.read(filterNotifierProvider.notifier).setMonthIndex(Filter(
        selectedAuthor: _selectedAuthor,
        selectedCategory: _selectedCategory,
        priceMin: _minPrice,
        priceMax: _maxPrice == 750 ? double.infinity : _maxPrice,
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin));
    _maxPrice = double.infinity == _maxPrice ? 1000 : _maxPrice;
    List<Book> books = await getBooks(
        text,
        _selectedAuthor ?? '',
        _selectedCategory ?? '',
        _minPrice.toString(),
        _maxPrice.toString(),
        _fechaInicio ?? '',
        _fechaFin ?? '');
    ref.read(bookNotifierProvider.notifier).setBooks(books);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
