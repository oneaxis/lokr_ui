import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokr_ui/secret.dart';

import 'messaging-service.dart';

class SecretCreationView extends StatefulWidget {
  const SecretCreationView({Key key}) : super(key: key);

  @override
  _SecretCreationViewState createState() => _SecretCreationViewState();
}

class _SecretCreationViewState extends State<SecretCreationView> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        _showOnPopDialog(context);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("New secret"),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                    'Here you find all your stored secrets. Just click on one of the '
                    'fields (e.g. password) to copy the content or extend the secret details.',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Divider(thickness: 1)),
              _SecretCreationForm(),
            ],
          )),
    );
  }
}

class _SecretCreationForm extends StatefulWidget {
  @override
  __SecretCreationFormState createState() => __SecretCreationFormState();
}

class __SecretCreationFormState extends State<_SecretCreationForm> {
  final _formKey = GlobalKey<FormState>();
  var _passwordController = TextEditingController(),
      _titleController = TextEditingController(),
      _usernameController = TextEditingController(),
      _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Your secret password...',
                    prefixIcon: Icon(Icons.vpn_key),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.emoji_symbols),
                      onPressed: () {},
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'A password is required!';
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Enter the secrets title/purpose...',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'A title is required!';
                    }
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Optional: Provide an username...',
                    prefixIcon: Icon(Icons.link),
                  ),
                  validator: (value) {
                    return null;
                  },
                )),
            Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: 'Optional: Provide an URL...',
                    prefixIcon: Icon(Icons.edit),
                  ),
                  validator: (value) {
                    return null;
                  },
                )),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8),
                  child: FlatButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      _showOnPopDialog(context);
                    },
                    child: Text("Cancel creation"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        Secret secret = Secret(
                          password: _passwordController.text,
                          title: _titleController.text,
                          username: _usernameController.text,
                          url: _urlController.text,
                        );
                        MessagingService.showSnackBarMessage(context, 'Processing Data for $secret');
                      }
                    },
                    child: Text('Store secret'),
                  ),
                )),
              ],
            ),
          ],
        ));
  }
}

void _showOnPopDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Leaving secret creation..."),
        content: new Text("You have not stored your secret yet. "
            "Your changes will be lost. Sure your want to go back?"),
        actions: <Widget>[
          FlatButton(
            child: new Text("Yes, go back"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: new Text("No, continue editing"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

String _generateRandomSecurePassword() {
  return 'somerandompassword';
}
