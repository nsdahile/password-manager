import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';
import 'package:path/path.dart' as path;

class BackupHelper {
  static Future<void> databaseBackup({
    @required String targetFolderPath,
    @required List<List<String>> accountList,
    String fileName = 'password-manager.csv',
  }) async {
    try {
      var targetLocation = path.join(targetFolderPath, fileName);
      var file = File(targetLocation);
      var fileText = accountListToCSV(accountList);
      await file.writeAsString(fileText);
    } catch (e) {
      throw e;
    }
  }

  static String accountListToCSV(List<List<String>> accountList) {
    String csv = ListToCsvConverter().convert(accountList);
    return csv;
  }
}
