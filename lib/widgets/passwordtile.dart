import 'package:flutter/material.dart';

class PasswordTile extends StatefulWidget {
  final String value;
  PasswordTile(this.value);
  @override
  _PasswordTileState createState() => _PasswordTileState();
}

class _PasswordTileState extends State<PasswordTile> {
  bool isHidden = true;
  // String password = '';

  @override
  void initState() {
    super.initState();
    // decryptPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            getValue,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            isHidden ? Icons.visibility_rounded : Icons.visibility_off_rounded,
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

  // void decryptPassword() async {
  //   password = await EncryptionHelper.decrypt(str: widget.value);
  //   setState(() {});
  // }
}
