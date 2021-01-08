//home screen

import 'package:flutter/material.dart';

import '../models/account_data.dart';

import 'add_account_screen.dart';

import '../widgets/list_accout_screen/accounts_list.dart';
import '../widgets/drawer.dart';

class ListAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Password Manager')),
      drawer: AppDrawer(),
      body: AccountsList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(
          context,
          AddAccountScreen.routeName,
          arguments: AccountData(),
        ),
      ),
    );
  }
}
