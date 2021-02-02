import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/url_helper.dart';

import 'passwordtile.dart';

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isPassword;
  final bool isUrl;
  InfoTile({
    @required this.label,
    @required this.value,
    this.isPassword = false,
    this.isUrl = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => copyOrLaunch(context),
      onLongPress: () => _copyToClipboard(context),
      splashColor: Theme.of(context).accentColor,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        constraints: BoxConstraints(minHeight: 30),
        // height: 30,
        child: Row(
          children: [
            SizedBox(
              width: 130,
              child: Text(
                label + ':',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: _getValue,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _getValue {
    if (!isPassword)
      return Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    return PasswordTile(value);
  }

  void copyOrLaunch(BuildContext context) {
    if (isUrl)
      _launchURL(context);
    else
      _copyToClipboard(context);
  }

  void _launchURL(BuildContext context) async {
    var url = UrlHellper.correctUrl(value);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to launch $value',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _copyToClipboard(BuildContext context) async {
    var massage = '$label copyed to clipboard';
    try {
      await FlutterClipboard.copy(value).then((_) {});
    } catch (e) {
      massage = 'Unable to copy';
    } finally {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(massage),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
