import 'package:flutter/material.dart';

import '../../models/account_data.dart';

class AccountTile extends StatelessWidget {
  final AccountData account;
  AccountTile(this.account);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(getTitle),
        subtitle: Text(getSubstitle),
      ),
    );
  }

  String get getTitle {
    if (account.url == null || account.url.length == 0) return "NA";
    return account.url;
  }

  String get getSubstitle {
    // Send username if available
    // else email if available
    // else send NA
    if (account.username == null || account.username.length == 0) {
      if (account.email == null || account.email.length == 0) {
        return "NA";
      }
      return account.email;
    }
    return account.username;
  }
}
