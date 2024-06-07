import 'package:flutter/material.dart';
import 'package:webir_frontend/constants/colors.dart';
import 'package:webir_frontend/models/book.dart';
import 'package:webir_frontend/widgets/appbar.dart';

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
      appBar: const BSAppbar(),
      body: Center(
        child: Row(
          children: [
            Container(
              color: BSConstants.tertiaryColor,
              width: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStarBars(context),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _buildBookTitle(context),
                  const Divider(),
                  _buildBookInfo(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(widget.book.title ?? '',
          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBookAdditionalData(context),
        _buildBookDescription(context),
      ],
    );
  }

  Widget _buildBookAdditionalData(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Autor: ${widget.book.author ?? ''}',
            style: const TextStyle(fontSize: 24)),
        Text('Precio: ${widget.book.price.toString()}',
            style: const TextStyle(fontSize: 24)),
        Text('ISBN: ${widget.book.id.toString()}',
            style: const TextStyle(fontSize: 24)),
      ],
    );
  }

  Widget _buildBookDescription(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Descripción:', style: TextStyle(fontSize: 24)),
        Text(widget.book.description ?? '',
            style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildStarBars(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Puntaje: ${widget.book.score?.stars ?? 0}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildStarBar(context, 5, widget.book.score?.fiveStarsPorcent),
          const SizedBox(height: 8),
          _buildStarBar(context, 4, widget.book.score?.fourStarsPorcent),
          const SizedBox(height: 8),
          _buildStarBar(context, 3, widget.book.score?.threeStarsPorcent),
          const SizedBox(height: 8),
          _buildStarBar(context, 2, widget.book.score?.twoStarsPorcent),
          const SizedBox(height: 8),
          _buildStarBar(context, 1, widget.book.score?.oneStarsPorcent),
        ],
      ),
    );
  }

  Widget _buildStarBar(
      BuildContext context, int starCount, double? percentage) {
    return Row(
      children: [
        Text('$starCount estrellas:'),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: (percentage ?? 0) / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(percentage ?? 0).toStringAsFixed(1)}%'),
      ],
    );
  }
}
