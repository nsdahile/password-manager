import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_tile.dart';

import '../../models/list_account_data.dart';

class AccountsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accounts = Provider.of<ListAccountData>(context).getAccounts();
    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (BuildContext context, int index) {
        return AccountTile(accounts[index]);
      },
    );
  }
}
