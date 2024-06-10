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
      appBar: BSAppbar(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          Positioned(
            left: MediaQuery.of(context).size.width * 0.2,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: MediaQuery.of(context).size.width * 0.8,
            child: Container(
              color: BSConstants.tertiaryColor,
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
        ],
      ),
    );
  }

  Widget _buildBookTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(widget.book.title ?? '',
              style:
                  const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text(widget.book.subtitle ?? '',
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
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
        widget.book.image != null
            ? Image.network(widget.book.image ?? '',
                width: 500, height: 500, fit: BoxFit.cover)
            : const SizedBox(),
        Text('Autor: ${widget.book.author ?? ''}',
            style: const TextStyle(fontSize: 24)),
        widget.book.price != null
            ? Text('Precio: ${widget.book.price.toString()}',
                style: const TextStyle(fontSize: 24))
            : const SizedBox(),
        Text('ISBN: ${widget.book.id.toString()}',
            style: const TextStyle(fontSize: 24)),
        Text('Editorial: ${widget.book.editorial ?? ''}',
            style: const TextStyle(fontSize: 24)),
        Text('Fecha de publicación: ${widget.book.fecha ?? ''}',
            style: const TextStyle(fontSize: 24)),
        Text('Páginas: ${widget.book.pages?.toString() ?? ''}',
            style: const TextStyle(fontSize: 24)),
        Text('Idioma: ${widget.book.language ?? ''}',
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
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          width: 600,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(widget.book.description ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 50,
                      softWrap: true,
                      style: const TextStyle(fontSize: 16)),
                ),
              ]),
        ),
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
