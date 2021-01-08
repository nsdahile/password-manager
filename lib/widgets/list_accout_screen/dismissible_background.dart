import 'package:flutter/material.dart';

class DismissibleBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          deleteIcon,
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Container get deleteIcon {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Icon(
        Icons.delete,
        size: 30,
        color: Colors.white70,
      ),
    );
  }
}
