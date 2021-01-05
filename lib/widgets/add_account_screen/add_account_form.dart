import 'package:flutter/material.dart';

class AddAccountFrom extends StatefulWidget {
  final Function setAccountIcon;
  final Function saveAccount;
  AddAccountFrom(this.setAccountIcon, this.saveAccount);
  @override
  _AddAccountFromState createState() => _AddAccountFromState();
}

class _AddAccountFromState extends State<AddAccountFrom> {
  final formKey = GlobalKey<FormState>();
  final passwordControler = TextEditingController();
  String url;
  String username;
  String email;
  String about;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Website Url',
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) => widget.setAccountIcon(value),
              validator: (value) {
                if (value.isEmpty) return null;
                if (!value.contains('.')) return "Please enter valid url";
                return null;
              },
              onSaved: (newValue) => url = newValue.trim(),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onSaved: (newValue) => username = newValue.trim(),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value.isEmpty) return null;
                if (!value.contains('@') || !value.contains('.'))
                  return 'Please enter valid  email';
                return null;
              },
              onSaved: (newValue) => email = newValue,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              obscureText: true,
              controller: passwordControler,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirm Password'),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              obscureText: true,
              validator: (value) {
                if (passwordControler.text != value)
                  return "Password does not match";
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'About'),
              onSaved: (newValue) => about = newValue,
            ),
            RaisedButton(child: Text('Save'), onPressed: save)
          ],
        ),
      ),
    );
  }

  void save() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if ((url == null || url.length == 0) &&
          (username == null || username.length == 0) &&
          (email == null || email.length == 0)) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Entered details are not valid, Please enter valid details.',
              textAlign: TextAlign.justify,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        );
        return;
      }
      try {
        await widget.saveAccount(
          url: url,
          username: username,
          email: email,
          password: passwordControler.text,
          about: about,
        );
      } catch (err) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to save account details.',
              textAlign: TextAlign.justify,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }
}
