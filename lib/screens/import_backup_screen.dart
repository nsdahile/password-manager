import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

import '../helper/backup_helper.dart';
import '../helper/db_helper.dart';
import '../helper/encryption_helper.dart';

// import '../models/encription_exception.dart';

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
  var keyController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    keyController.dispose();
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
              InfoTile(label: 'File location', value: filePath),
              InfoTile(label: 'File name', value: fileName),
              TextField(
                decoration: InputDecoration(labelText: 'Key'),
                controller: keyController,
              ),
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
        ),
      ),
    );
  }

  void importBackup() async {
    FocusScope.of(context).unfocus();
    var massage = 'Import Successful';
    try {
      if (fileName.isEmpty || filePath.isEmpty) {
        massage = 'Please select file';
      } else if (keyController.text == null || keyController.text.isEmpty) {
        massage = 'Please enter key';
      } else {
        //getting content of file
        var contentList =
            await BackupHelper.databaseImportBackup(filePath: filePath);
        //inserting accounts in database
        for (var accountList in contentList) {
          var decrypedPassword;
          try {
            decrypedPassword =
                await decryptThenEncrypt(accountList[3], keyController.text);
            await DBHelper.insert(
              url: accountList[0],
              username: accountList[1],
              email: accountList[2],
              password: decrypedPassword,
              about: accountList[4],
              imageUrl: accountList[5],
              date: DateTime.parse(accountList[6]),
            );
          } catch (e) {
            massage = e.massage;
            break;
          }
        }
        //notifying all accounts list listening screens
        await Provider.of<ListAccountData>(context, listen: false)
            .refreshFromDBNotifyListener();
      }
    } catch (err) {
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

  Future<String> decryptThenEncrypt(String password, String oldKey) async {
    if (await EncryptionHelper.getKey() == oldKey) return password;
    try {
      var decryptedPassword =
          await EncryptionHelper.decrypt(str: password, key: oldKey);
      var encryptedPassword = await EncryptionHelper.encript(decryptedPassword);
      return encryptedPassword;
    } catch (err) {
      throw (err);
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
