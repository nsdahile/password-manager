import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/show_account_details_screen/info_tile.dart';

import '../models/account_data.dart';

class ShowAccountDetailsScreen extends StatelessWidget {
  static final routeName = 'show-website-details';

  @override
  Widget build(BuildContext context) {
    final account = ModalRoute.of(context).settings.arguments as AccountData;
    return Scaffold(
      appBar: AppBar(
        title: Text(account.url.toUpperCase()),
      ),
      body: Card(
        child: ListView(
          children: [
            InfoTile(
              label: 'URL',
              value: getValue(account.url),
              isUrl: true,
            ),
            InfoTile(label: 'Username', value: getValue(account.username)),
            InfoTile(label: 'Email', value: getValue(account.email)),
            InfoTile(
              label: 'Password',
              value: getValue(account.password),
              isPassword: true,
            ),
            InfoTile(label: 'About', value: getValue(account.about)),
            InfoTile(
              label: 'Date of creation',
              value: DateFormat.yMMMEd().format(account.date),
            ),
          ],
        ),
      ),
    );
  }

  String getValue(String value) {
    if (value == null || value.length == 0) return "NA";
    return value;
  }
}
