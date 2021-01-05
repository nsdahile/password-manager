import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/show_account_details_screen.dart';
import '../../widgets/account_image.dart';
import 'dismissible_background.dart';

import '../../models/account_data.dart';
import '../../providers/list_account_data.dart';

class AccountTile extends StatefulWidget {
  final AccountData account;
  final int accountIndex;
  AccountTile(this.account, this.accountIndex);

  @override
  _AccountTileState createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.account.date),
      background: DismissibleBackground(),
      direction: DismissDirection.endToStart,
      onDismissed: deleteAccount,
      child: Card(
        child: ListTile(
          leading: AccountImage(widget.account.imageUrl),
          title: Text(getTitle),
          subtitle: Text(getSubstitle),
          onTap: openShowAccountDetailsScreen,
        ),
      ),
    );
  }

  void openShowAccountDetailsScreen() {
    Navigator.of(context).pushNamed(
      ShowAccountDetailsScreen.routeName,
      arguments: widget.account,
    );
  }

  void deleteAccount(direction) async {
    var massage = 'Account Deleted';
    try {
      await Provider.of<ListAccountData>(context, listen: false)
          .deleteAccount(widget.accountIndex);
    } catch (e) {
      massage = 'Delete Failed';
    } finally {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            massage,
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          width: 150,
        ),
      );
    }
  }

  String get getTitle {
    if (widget.account.url == null || widget.account.url.length == 0)
      return "NA";
    return widget.account.url;
  }

  String get getSubstitle {
    // Send username if available
    // else email if available
    // else send NA
    if (widget.account.username == null ||
        widget.account.username.length == 0) {
      if (widget.account.email == null || widget.account.email.length == 0) {
        return "NA";
      }
      return widget.account.email;
    }
    return widget.account.username;
  }
}
