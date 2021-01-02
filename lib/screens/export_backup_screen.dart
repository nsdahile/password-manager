import 'dart:io';

import 'package:flutter/material.dart';

import 'package:folder_picker/folder_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../helper/backup_helper.dart';
import '../providers/list_account_data.dart';

class ExportBackupScreen extends StatelessWidget {
  static final routeName = '/export-database-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export Backup'),
      ),
      body: ExportBackupScreenBody(),
    );
  }
}

class ExportBackupScreenBody extends StatefulWidget {
  @override
  _ExportBackupScreenBodyState createState() => _ExportBackupScreenBodyState();
}

class _ExportBackupScreenBodyState extends State<ExportBackupScreenBody> {
  var targetFolder = '/storage/emulated/0/';
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Export Location:'),
              Expanded(child: Text(targetFolder))
            ],
          ),
          RaisedButton(
            onPressed: exportLocationPicker,
            child: Text('Select Folder'),
          ),
          RaisedButton(
            onPressed: exportBackup,
            child: Text('Export Backup'),
          ),
        ],
      ),
    );
  }

  void exportBackup() async {
    var massage = 'Export Successful';
    try {
      if (targetFolder != null || targetFolder.isNotEmpty) {
        await BackupHelper.databaseBackup(
          targetFolderPath: targetFolder,
          accountList: Provider.of<ListAccountData>(context, listen: false)
              .toNestedListOfString(),
        );
      }
    } catch (e) {
      massage = 'Export Unsuccessful';
    } finally {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(massage),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> exportLocationPicker() async {
    var hasPermission = await Permission.storage.isGranted;
    if (!hasPermission) {
      var permissionStatus = await Permission.storage.request();
      if (permissionStatus != PermissionStatus.granted) return null;
    }
    //after having permission
    await Navigator.of(context).push<FolderPickerPage>(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return FolderPickerPage(
            rootDirectory: Directory('/storage/emulated/0/'),
            action: (BuildContext context, Directory folder) async {
              setState(() {
                targetFolder = folder.path;
              });
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
