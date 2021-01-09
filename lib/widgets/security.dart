import 'package:flutter/material.dart';

import '../helper/applock_helper.dart';

import '../screens/pass_code_screen.dart';

class Security extends StatefulWidget {
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  bool state = true;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.security_rounded),
      title: Text(
        'Security',
        style: TextStyle(fontSize: 16),
      ),
      trailing: Switch(
        value: AppLockHelper.getPascodeState(),
        onChanged: toggleLockActiveState,
      ),
    );
  }

  void toggleLockActiveState(bool newState) {
    if (newState) {
      turnOnLock();
    } else {
      turnOffLock();
    }
  }

  void turnOnLock() async {
    List<int> firstPasscode;
    List<int> secondPasscode;
    await Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => PassCodeScreen(
              title: 'Enter New Passcode',
              isUpdate: true,
            ),
          ),
        )
        .then((value) => firstPasscode = value);
    await Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => PassCodeScreen(
              title: 'Confirm New Passcode',
              isUpdate: true,
            ),
          ),
        )
        .then((value) => secondPasscode = value);

    if (areListEqual(firstPasscode, secondPasscode)) {
      await AppLockHelper.setPasscode(firstPasscode);
      setState(() {});
    } else {
      Navigator.of(context).pop();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Passcode Does Not Match',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          width: 200,
        ),
      );
    }
  }

  bool areListEqual(List<int> list1, List<int> list2) {
    // check if both are lists
    if (!(list1 is List && list2 is List)
        // check if both have same length
        ||
        list1.length != list2.length) {
      return false;
    }

    // check if elements are equal
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    return true;
  }

  void turnOffLock() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('App Lock'),
          content: Text('Do you want to turn off app lock?'),
          actions: [
            TextButton(
              child: Text(
                'NO',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await AppLockHelper.deletePasscode();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}
