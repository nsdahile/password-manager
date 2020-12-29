import 'package:flutter/foundation.dart';

import '../models/account_data.dart';
import '../helper/db_helper.dart';

class ListAccountData with ChangeNotifier {
  List<AccountData> _accounts = [];

  Future<List<AccountData>> getAccounts() async {
    if (_accounts.length > 0) return [..._accounts];
    //featching account details from database
    try {
      var accountsFromDB = await DBHelper.getAccountsFromDB();
      accountsFromDB.forEach(
        (account) => _accounts.add(
          AccountData(
            date: DateTime.parse(account['date']),
            url: account['url'],
            username: account['username'],
            email: account['email'],
            password: account['password'],
            about: account['about'],
          ),
        ),
      );
      return [..._accounts];
    } catch (error) {
      //TODO: Perform error handeling
      print('*********${error.massage}**********');
    }
  }

  Future<void> addAccount({
    String url,
    String username,
    String email,
    String password,
    String about,
  }) async {
    var date = DateTime.now();
    try {
      //adding accout to database
      await DBHelper.insert(
        date: date,
        url: url,
        username: username,
        email: email,
        password: password,
        about: about,
      );
      //adding account to memory
      var newAccount = AccountData(
        date: date,
        url: url,
        username: username,
        email: email,
        password: password,
        about: about,
      );
      _accounts.add(newAccount);

      notifyListeners();
    } catch (error) {
      //TODO: Handle Error
      print('**********${error.massage}**************');
    }
  }
}
