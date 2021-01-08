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
  final websiteUrlControler = TextEditingController();
  var tryedToSetImage = false;
  String url;
  String username;
  String email;
  String about;

  @override
  void dispose() {
    passwordControler.dispose();
    websiteUrlControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Website Url',
                  icon: Icon(Icons.language),
                ),
                controller: websiteUrlControler,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  tryedToSetImage = true;
                  widget.setAccountIcon(value);
                },
                validator: (value) {
                  if (value.isEmpty) return null;
                  if (!value.contains('.')) return "Please enter valid url";
                  return null;
                },
                onSaved: (newValue) => url = newValue.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  icon: Icon(Icons.account_circle),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onSaved: (newValue) => username = newValue.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
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
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.vpn_key),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                obscureText: true,
                controller: passwordControler,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  icon: Icon(Icons.vpn_key),
                ),
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
                decoration: InputDecoration(
                  labelText: 'About',
                  icon: Icon(Icons.short_text),
                ),
                onSaved: (newValue) => about = newValue,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton(child: Text('Save'), onPressed: save),
              ),
            ],
          ),
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
      if (!tryedToSetImage) {
        await widget.setAccountIcon(websiteUrlControler.text);
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
