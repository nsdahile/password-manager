import 'dart:ui';

import 'package:flutter/material.dart';

import '../screens/export_backup_screen.dart';
import '../screens/import_backup_screen.dart';
import '../widgets/security.dart';

class AppDrawer extends StatelessWidget {
  final _textStyle = TextStyle(fontSize: 16);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                'Password Manager',
                style: TextStyle(
                  fontFamily: 'Lobster',
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Security(),
          Divider(thickness: 1),
          ListTile(
            leading: Icon(Icons.upload_rounded),
            title: Text(
              'Export Backup',
              style: _textStyle,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ExportBackupScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.download_rounded),
            title: Text(
              'Import Backup',
              style: _textStyle,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ImportBackupScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
