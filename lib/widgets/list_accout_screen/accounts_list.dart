import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_tile.dart';

import '../../models/account_data.dart';
import '../../providers/list_account_data.dart';

class AccountsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AccountData>>(
      future: Provider.of<ListAccountData>(context).getAccounts(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        final accounts = snapshot.data;
        return ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (BuildContext context, int index) {
            return AccountTile(accounts[index], index);
          },
        );
      },
    );
  }
}
