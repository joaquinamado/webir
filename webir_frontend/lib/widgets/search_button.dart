import 'package:flutter/material.dart';
import 'package:webir_frontend/constants/colors.dart';

class BSFilterButton extends StatefulWidget {
  const BSFilterButton({Key? key}) : super(key: key);

  @override
  createState() => _BSFilterButtonState();
}

class _BSFilterButtonState extends State<BSFilterButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showFilterMenu(context);
        },
        icon: const Icon(Icons.settings, color: Colors.white),
        style: ElevatedButton.styleFrom(
            side: const BorderSide(color: BSConstants.tertiaryColor),
            minimumSize: const Size(50, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: BSConstants.tertiaryColor));
  }

  void showFilterMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.topRight(const Offset(60, 0)),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final List<PopupMenuEntry<dynamic>> items = [
      const PopupMenuItem(
        value: 0,
        child: Text('Title'),
      ),
      const PopupMenuItem(
        value: 0,
        child: Text('Category'),
      )
    ];
    showMenu(
      context: context,
      position: position,
      items: items,
      elevation: 8,
    ).then((value) {
      if (value != null) {
        setState(() {});
      }
    });
  }
}
