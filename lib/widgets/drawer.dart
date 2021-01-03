import 'package:flutter/material.dart';

import '../screens/export_backup_screen.dart';
import '../screens/import_backup_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              'Password Mannager',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 25,
              ),
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          ListTile(
            leading: Icon(Icons.security_rounded),
            title: Text('Security'),
          ),
          Divider(thickness: 1),
          ListTile(
            leading: Icon(Icons.upload_rounded),
            title: Text('Export Backup'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(ExportBackupScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.download_rounded),
            title: Text('Import Backup'),
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
