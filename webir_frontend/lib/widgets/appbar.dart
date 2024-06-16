import 'package:flutter/material.dart';
import 'package:webir_frontend/constants/colors.dart';

class BSAppbar extends StatefulWidget implements PreferredSizeWidget {
  const BSAppbar({Key? key, required this.onPressed}) : super(key: key);
  final VoidCallback? onPressed;

  @override
  State<BSAppbar> createState() => _BSAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _BSAppbarState extends State<BSAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: BSConstants.tertiaryColor,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back), onPressed: widget.onPressed),
      automaticallyImplyLeading: false,
      title: const Text('ReadIt',
          style: TextStyle(color: Colors.white, fontSize: 24.0)),
    );
  }
}
