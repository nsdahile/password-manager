import 'package:flutter/material.dart';
import 'package:flutter_lock_screen/flutter_lock_screen.dart';

import 'list_accounts_screen.dart';

import '../helper/applock_helper.dart';

class PassCodeScreen extends StatefulWidget {
  final String title;
  final bool isUpdate;
  PassCodeScreen({
    this.title = "Enter Your Passcode",
    this.isUpdate = false,
  });

  @override
  _PassCodeScreenState createState() => new _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  List<int> myPass;

  @override
  Widget build(BuildContext context) {
    return LockScreen(
      title: widget.title,
      passLength: 4,
      bgImage: "assets/images/pass_code_bg.jpg",
      fingerPrintImage: null,
      showFingerPass: false,
      fingerFunction: null,
      fingerVerify: false,
      borderColor: Colors.white,
      showWrongPassDialog: true,
      wrongPassContent: "Wrong passcode please try again.",
      wrongPassTitle: "Opps!",
      wrongPassCancelButtonText: "Cancel",
      passCodeVerify: widget.isUpdate ? setPasscode : verifyPasscode,
      onSuccess: widget.isUpdate ? returnPasscode : launchApp,
    );
  }

  Future<bool> verifyPasscode(List<int> passcode) async {
    await AppLockHelper.getPasscode().then((value) => myPass = value);
    for (int i = 0; i < myPass.length; i++) {
      if (passcode[i] != myPass[i]) {
        return false;
      }
    }
    return true;
  }

  void launchApp() {
    Navigator.of(context).pushReplacementNamed(ListAccountScreen.routeName);
  }

  Future<bool> setPasscode(List<int> passcode) async {
    myPass = passcode;
    return true;
  }

  void returnPasscode() {
    Navigator.of(context).pop(myPass);
  }
}
