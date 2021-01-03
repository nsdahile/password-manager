import 'package:flutter/material.dart';

class PasswordTile extends StatefulWidget {
  final String value;
  PasswordTile(this.value);
  @override
  _PasswordTileState createState() => _PasswordTileState();
}

class _PasswordTileState extends State<PasswordTile> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(getValue),
        ),
        IconButton(
          icon: Icon(
            Icons.remove_red_eye_rounded,
          ),
          splashColor: Theme.of(context).accentColor,
          onPressed: changeHiddenState,
        ),
      ],
    );
  }

  String get getValue {
    if (isHidden) return '●' * widget.value.length;
    return widget.value;
  }

  void changeHiddenState() {
    setState(() {
      isHidden = !isHidden;
    });
  }
}