import 'package:flutter/material.dart';

class DismissibleBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          deleteIcon,
        ],
      ),
      color: Colors.red,
    );
  }

  Container get deleteIcon {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Icon(Icons.delete_forever_sharp, size: 30, color: Colors.white70),
    );
  }
}
