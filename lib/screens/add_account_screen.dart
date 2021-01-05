import 'package:flutter/material.dart';
import 'package:password_manager/helper/account_image_helper.dart';
import 'package:provider/provider.dart';

import '../providers/list_account_data.dart';
import '../helper/url_helper.dart';

import '../widgets/add_account_screen/add_account_form.dart';
import '../widgets/account_image.dart';

class AddAccountScreen extends StatefulWidget {
  static final routeName = 'add-account-screen';
  @override
  _AddAccountScreenState createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  String imageUrl = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isLoading
                ? Container(
                    child: CircularProgressIndicator(),
                    padding: EdgeInsets.all(10),
                    height: 40,
                    width: 40,
                  )
                : AccountImage(imageUrl),
            Text('Add Account'),
          ],
        ),
      ),
      body: AddAccountFrom(setAccountIcon, saveAccount),
    );
  }

  void setAccountIcon(String webUrl) async {
    setState(() => isLoading = true);
    webUrl = UrlHellper.correctUrl(webUrl);

    try {
      var url = await AccountImageHelper.getIcon(webUrl);
      imageUrl = url;
    } catch (err) {
      //error from account image helper
      imageUrl = '';
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> saveAccount({
    String url,
    String username,
    String email,
    String password,
    String about,
  }) async {
    try {
      Provider.of<ListAccountData>(context, listen: false).addAccount(
        url: url,
        username: username,
        email: email,
        password: password,
        about: about,
        imageUrl: imageUrl,
      );
    } catch (e) {
      throw e;
    }
  }
}
