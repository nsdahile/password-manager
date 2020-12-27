import 'package:flutter/material.dart';

import '../../models/account_data.dart';

class AccountTile extends StatelessWidget {
  final AccountData account;
  AccountTile(this.account);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(account.url ?? "NA"),
      subtitle: Text(account.username ?? account.email ?? "NA"),
    );
  }
}
