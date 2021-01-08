import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/list_account_data.dart';

import 'screens/list_accounts_screen.dart';
import 'screens/add_account_screen.dart';
import 'screens/show_account_details_screen.dart';
import 'screens/export_backup_screen.dart';
import 'screens/import_backup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListAccountData(),
      child: MaterialApp(
        title: 'Password Manager',
        theme: ThemeData(
            primaryColor: Colors.grey[800],
            accentColor: Colors.amber,
            appBarTheme: ThemeData.light().appBarTheme.copyWith(
                  textTheme: TextTheme(
                    headline6: TextStyle(
                      fontFamily: 'Lobster',
                      fontSize: 25,
                    ),
                  ),
                  centerTitle: true,
                ),
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.amber,
              textTheme: ButtonTextTheme.primary,
            )),
        home: ListAccountScreen(),
        routes: {
          ShowAccountDetailsScreen.routeName: (context) =>
              ShowAccountDetailsScreen(),
          AddAccountScreen.routeName: (context) => AddAccountScreen(),
          ExportBackupScreen.routeName: (context) => ExportBackupScreen(),
          ImportBackupScreen.routeName: (context) => ImportBackupScreen(),
        },
      ),
    );
  }
}
