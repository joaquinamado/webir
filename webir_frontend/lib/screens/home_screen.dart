import 'package:flutter/material.dart';
import 'package:webir_frontend/constants/colors.dart';
import 'package:webir_frontend/screens/search_results_screen.dart';
import 'package:webir_frontend/widgets/appbar.dart';
import 'package:webir_frontend/widgets/elevated_button.dart';
import 'package:webir_frontend/widgets/search_button.dart';
import 'package:webir_frontend/widgets/textform_field.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String path = '/';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController controller = TextEditingController();
  int _selectedFilter = 0;
  double _minPrice = 0;
  double _maxPrice = 1000;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BSAppbar(),
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
                        onPressed: () {
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
                Row(
                  children: [
                    BSElevatedButton(
                        label: 'Titulo',
                        isSelected: _selectedFilter == 0,
                        onPressed: () {
                          setState(() {
                            _selectedFilter = 0;
                          });
                        },
                        width: 120,
                        height: 50),
                    const SizedBox(width: 10),
                    BSElevatedButton(
                        label: 'Categoria',
                        isSelected: _selectedFilter == 1,
                        onPressed: () {
                          setState(() {
                            _selectedFilter = 1;
                          });
                        },
                        width: 120,
                        height: 50),
                    const SizedBox(width: 10),
                    BSElevatedButton(
                        label: 'Autor',
                        isSelected: _selectedFilter == 2,
                        onPressed: () {
                          setState(() {
                            _selectedFilter = 2;
                          });
                        },
                        width: 120,
                        height: 50),
                  ],
                ),
                SizedBox(
                  width: 400,
                  height: 40,
                  child: RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
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
                          'Max: ${_maxPrice == double.infinity ? 'Unlimited' : '\$${_maxPrice.toStringAsFixed(2)}'}'),
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

  void _searchBooks(String text) {}
}
