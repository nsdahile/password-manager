import 'package:flutter/material.dart';

import '../../helper/encryption_helper.dart';

import '../../models/account_data.dart';

class AddAccountFrom extends StatefulWidget {
  final Function setAccountIcon;
  final Function saveAccount;
  final Function updateAccount;
  final AccountData currentUserAccount;
  AddAccountFrom({
    @required this.setAccountIcon,
    @required this.saveAccount,
    @required this.updateAccount,
    @required this.currentUserAccount,
  });
  @override
  _AddAccountFromState createState() => _AddAccountFromState();
}

class _AddAccountFromState extends State<AddAccountFrom> {
  final formKey = GlobalKey<FormState>();
  final urlControler = TextEditingController();
  final usernameControler = TextEditingController();
  final emailControler = TextEditingController();
  final passwordControler = TextEditingController();
  final confirmPasswordControler = TextEditingController();
  final aboutControler = TextEditingController();
  var isUpdate = false;
  var tryedToSetImage = false;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    urlControler.text = widget.currentUserAccount.url;
    usernameControler.text = widget.currentUserAccount.username;
    emailControler.text = widget.currentUserAccount.email;
    passwordControler.text = '';
    confirmPasswordControler.text = passwordControler.text;
    aboutControler.text = widget.currentUserAccount.about;
    if (!isFormEmpty()) isUpdate = true;
    setPassword();
  }

  @override
  void dispose() {
    urlControler.dispose();
    usernameControler.dispose();
    emailControler.dispose();
    passwordControler.dispose();
    confirmPasswordControler.dispose();
    aboutControler.dispose();
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
                controller: urlControler,
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
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  icon: Icon(Icons.account_circle),
                ),
                controller: usernameControler,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                controller: emailControler,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) return null;
                  if (!value.contains('@') || !value.contains('.'))
                    return 'Please enter valid  email';
                  return null;
                },
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
                controller: confirmPasswordControler,
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
                controller: aboutControler,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton(
                  child: Text(isUpdate ? 'Update' : 'Save'),
                  onPressed: isLoading ? null : save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setPassword() async {
    if (widget.currentUserAccount.password == null ||
        widget.currentUserAccount.password.isEmpty) return;
    passwordControler.text =
        await EncryptionHelper.decrypt(str: widget.currentUserAccount.password);
    setState(() {
      confirmPasswordControler.text = passwordControler.text;
    });
  }

  bool isFormEmpty() {
    if ((urlControler.text == null || urlControler.text.length == 0) &&
        (usernameControler.text == null ||
            usernameControler.text.length == 0) &&
        (emailControler.text == null || emailControler.text.length == 0)) {
      return true;
    }
    return false;
  }

  bool isImageUrlCorrect() {
    if (tryedToSetImage)
      return true;
    else if (widget.currentUserAccount.url != null &&
        widget.currentUserAccount.url != urlControler.text)
      return false;
    else if (widget.currentUserAccount.url != null &&
        widget.currentUserAccount.url == urlControler.text) return true;
    return false;
  }

  void save() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState.validate()) {
      setState(() => isLoading = true);
      formKey.currentState.save();
      if (isFormEmpty()) {
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
      if (!isImageUrlCorrect()) {
        await widget.setAccountIcon(urlControler.text);
      }
      try {
        if (isUpdate) {
          await widget.updateAccount(
            oldAccount: widget.currentUserAccount,
            url: urlControler.text,
            username: usernameControler.text,
            email: emailControler.text,
            password: await EncryptionHelper.encript(passwordControler.text),
            about: aboutControler.text,
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          //creating new account
          await widget.saveAccount(
            url: urlControler.text,
            username: usernameControler.text,
            email: emailControler.text,
            password: await EncryptionHelper.encript(passwordControler.text),
            about: aboutControler.text,
          );
          Navigator.of(context).pop();
        }
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
      setState(() => isLoading = false);
    }
  }
}
