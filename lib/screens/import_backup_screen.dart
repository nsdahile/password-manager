import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

import '../helper/backup_helper.dart';
import '../helper/db_helper.dart';

import '../providers/list_account_data.dart';

import '../widgets/info_tile.dart';

class ImportBackupScreen extends StatelessWidget {
  static final routeName = '/import-backup-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import Backup'),
      ),
      body: ImportBackupScreenBody(),
    );
  }
}

class ImportBackupScreenBody extends StatefulWidget {
  @override
  _ImportBackupScreenBodyState createState() => _ImportBackupScreenBodyState();
}

class _ImportBackupScreenBodyState extends State<ImportBackupScreenBody> {
  var fileName = '';
  var filePath = '';
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InfoTile(label: 'File location', value: filePath),
          InfoTile(label: 'File name', value: fileName),
          RaisedButton(
            onPressed: pickFile,
            child: Text('Select File'),
          ),
          RaisedButton(
            onPressed: importBackup,
            child: Text('Import Backup'),
          ),
        ],
      ),
    );
  }

  void importBackup() async {
    var massage = 'Import Successful';
    try {
      if (fileName.isEmpty || filePath.isEmpty) {
        massage = 'Please select file';
      } else {
        //getting content of file
        var contentList =
            await BackupHelper.databaseImportBackup(filePath: filePath);
        //inserting accounts in database
        contentList.forEach((accountList) {
          DBHelper.insert(
            url: accountList[0],
            username: accountList[1],
            email: accountList[2],
            password: accountList[3],
            about: accountList[4],
            date: DateTime.parse(accountList[5]),
          );
        });
        //notifying all accounts list listening screens
        Provider.of<ListAccountData>(context, listen: false)
            .refreshFromDBNotifyListener();
      }
    } catch (e) {
      massage = 'Unable to import file';
    } finally {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(massage),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> pickFile() async {
    //ask for storage permission if dont have
    var hasPermission = await Permission.storage.isGranted;
    if (!hasPermission) {
      var permissinStatus = await Permission.storage.request();
      if (permissinStatus != PermissionStatus.granted) return;
    }
    //Pick file has got permission
    FlutterDocumentPickerParams params =
        FlutterDocumentPickerParams(allowedFileExtensions: ['csv']);
    final path = await FlutterDocumentPicker.openDocument(params: params);
    if (path == null || path.isEmpty) return;
    setState(() {
      filePath = path;
      fileName = path.split('/').last;
    });
  }
}
