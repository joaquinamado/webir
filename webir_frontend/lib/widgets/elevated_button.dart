import 'package:flutter/material.dart';
import 'package:webir_frontend/constants/colors.dart';

class BSElevatedButton extends StatefulWidget {
  const BSElevatedButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      this.width,
      this.height,
      this.isSelected})
      : super(key: key);
  final String label;
  final double? width;
  final double? height;
  final bool? isSelected;
  final void Function() onPressed;

  @override
  createState() => _BSElevatedButtonState();
}

class _BSElevatedButtonState extends State<BSElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 360,
      height: widget.height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            side: BorderSide(
                color: widget.isSelected == true
                    ? Colors.brown
                    : BSConstants.tertiaryColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: widget.isSelected == true
                ? Colors.brown
                : BSConstants.tertiaryColor),
        onPressed: widget.onPressed,
        child: Text(widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}
