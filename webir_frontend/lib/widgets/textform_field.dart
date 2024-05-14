import 'package:flutter/material.dart';

class BSTextFormField extends StatefulWidget {
  const BSTextFormField(
      {Key? key, required this.label, required this.controller})
      : super(key: key);
  final String label;
  final TextEditingController controller;

  @override
  createState() => _BSTextFormFieldState();
}

class _BSTextFormFieldState extends State<BSTextFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 50,
      child: TextFormField(
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
