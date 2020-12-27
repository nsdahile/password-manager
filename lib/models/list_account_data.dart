import 'package:flutter/foundation.dart';

import 'account_data.dart';

class ListAccountData with ChangeNotifier {
  List<AccountData> _accounts = [];

  List<AccountData> getAccounts() {
    return [..._accounts];
  }

  void addAccount({
    String url,
    String username,
    String email,
    String password,
    String about,
  }) {
    var newAccount = AccountData(
      url: url,
      username: username,
      email: email,
      password: password,
      about: about,
      date: DateTime.now(),
    );
    _accounts.add(newAccount);

    notifyListeners();
  }
}
