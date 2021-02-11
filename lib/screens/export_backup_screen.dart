import 'dart:io';

import 'package:flutter/material.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../helper/backup_helper.dart';
import '../helper/encryption_helper.dart';
import '../providers/list_account_data.dart';

import '../widgets/info_tile.dart';

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
  var encryptionKey = '';
  var fileNamecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setEncryptionKey();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'File name',
                  helperText: 'password-manager (default)',
                ),
                controller: fileNamecontroller,
              ),
              InfoTile(label: 'Key', value: encryptionKey),
              InfoTile(label: 'Export Location', value: targetFolder),
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
        ),
      ),
    );
  }

  void setEncryptionKey() async {
    try {
      encryptionKey = await EncryptionHelper.getKey();
    } catch (e) {}
    setState(() {});
  }

  void exportBackup() async {
    FocusScope.of(context).unfocus();

    var massage = 'Export Successful';
    try {
      if (targetFolder != null || targetFolder.isNotEmpty) {
        await BackupHelper.databaseExportBackup(
          targetFolderPath: targetFolder,
          accountList: Provider.of<ListAccountData>(context, listen: false)
              .toNestedListOfString(),
          fileName: fileNamecontroller.text.isNotEmpty
              ? fileNamecontroller.text
              : 'password-manager.csv',
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
    FocusScope.of(context).unfocus();

    var hasPermission = await Permission.storage.isGranted;
    if (!hasPermission) {
      var permissionStatus = await Permission.storage.request();
      if (permissionStatus != PermissionStatus.granted) return null;
    }

    String path = await FilesystemPicker.open(
      title: 'Save to folder',
      context: context,
      rootDirectory: Directory('/storage/emulated/0/'),
      fsType: FilesystemType.folder,
      pickText: 'Save file to this folder',
      folderIconColor: Colors.teal,
    );
    setState(() {
      targetFolder = path;
    });
  }
}
