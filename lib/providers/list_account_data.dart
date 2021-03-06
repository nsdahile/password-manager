import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/account_data.dart';
import '../helper/db_helper.dart';

class ListAccountData with ChangeNotifier {
  List<AccountData> _accounts = [];

  Future<List<AccountData>> getAccounts() async {
    if (_accounts.length > 0) return UnmodifiableListView(_accounts);
    //featching account details from database
    try {
      await refreshFromDB();
      return UnmodifiableListView(_accounts);
    } catch (error) {
      //if error occured then empty is returned. no data displayed.
      return [];
    }
  }

  Future<void> refreshFromDB() async {
    _accounts = [];
    var accountsFromDB = await DBHelper.getAccountsFromDB();
    accountsFromDB.forEach(
      (account) => _accounts.insert(
        0,
        AccountData(
          date: DateTime.parse(account['date']),
          url: account['url'],
          username: account['username'],
          email: account['email'],
          password: account['password'],
          about: account['about'],
          imageUrl: account['imageUrl'],
        ),
      ),
    );
  }

  Future<void> refreshFromDBNotifyListener() async {
    await refreshFromDB();
    notifyListeners();
  }

  Future<void> addAccount({
    String url,
    String username,
    String email,
    String password,
    String about,
    String imageUrl,
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
        imageUrl: imageUrl,
      );
      //adding account to memory
      var newAccount = AccountData(
        date: date,
        url: url,
        username: username,
        email: email,
        password: password,
        about: about,
        imageUrl: imageUrl,
      );
      _accounts.insert(0, newAccount);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateAccount(
      AccountData oldAccount, AccountData newAccount) async {
    try {
      await addAccount(
        url: newAccount.url,
        username: newAccount.username,
        email: newAccount.email,
        password: newAccount.password,
        about: newAccount.about,
        imageUrl: newAccount.imageUrl,
      );
      var deleteAccountIndex =
          _accounts.indexWhere((account) => account.date == oldAccount.date);
      await deleteAccount(deleteAccountIndex);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteAccount(int accountIndex) async {
    try {
      await DBHelper.delete(_accounts[accountIndex].date);
      _accounts.removeAt(accountIndex);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<List<String>> toNestedListOfString() {
    List<List<String>> accountList = [];
    _accounts.forEach((account) {
      List<String> accountDataList = [];
      accountDataList.add(account.url);
      accountDataList.add(account.username);
      accountDataList.add(account.email);
      accountDataList.add(account.password);
      accountDataList.add(account.about);
      accountDataList.add(account.imageUrl);
      accountDataList.add(account.date.toIso8601String());
      accountList.add(accountDataList);
    });
    return accountList;
  }
}
