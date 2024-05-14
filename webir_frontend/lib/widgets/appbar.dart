import 'package:flutter/material.dart';
import 'package:webir_frontend/constants/colors.dart';

class BSAppbar extends StatefulWidget implements PreferredSizeWidget {
  const BSAppbar({Key? key}) : super(key: key);

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
      title: const Text('BookSearch',
          style: TextStyle(color: Colors.white, fontSize: 24.0)),
    );
  }
}
