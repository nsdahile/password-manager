import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/add_account_screen.dart';
import '../widgets/info_tile.dart';
import '../widgets/account_image.dart';

import '../models/account_data.dart';

class ShowAccountDetailsScreen extends StatelessWidget {
  static final routeName = 'show-website-details';

  @override
  Widget build(BuildContext context) {
    var account = ModalRoute.of(context).settings.arguments as AccountData;
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AccountImage(account.imageUrl),
              Text(account.url.toUpperCase()),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pushNamed(
              AddAccountScreen.routeName,
              arguments: account,
            ),
          ),
        ],
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
              label: 'Last Update',
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
