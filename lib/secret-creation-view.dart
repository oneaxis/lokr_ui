import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokr_ui/secret.dart';
import 'package:lokr_ui/validator.dart';

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
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                      'Here you find all your stored secrets. Just click on one of the '
                      'fields (e.g. password) to copy the content or extend the secret details.',
                      style: Theme.of(context).textTheme.bodyText1),
                  Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Divider(thickness: 1)),
                  _SecretCreationForm(),
                ],
              )),
        ),
      ),
    );
  }
}

class _SecretCreationForm extends StatefulWidget {
  @override
  __SecretCreationFormState createState() => __SecretCreationFormState();
}

class __SecretCreationFormState extends State<_SecretCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController(),
      _titleController = TextEditingController(),
      _usernameController = TextEditingController(),
      _urlController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _passwordController.dispose();
    _titleController.dispose();
    _usernameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            _TextFormField('Your secret password...',
                obscureText: _isPasswordHidden,
                controller: _passwordController,
                prefix: Icon(Icons.vpn_key),
                suffix: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // added line
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: _isPasswordHidden
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () {
                          this.togglePasswordVisibility();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.emoji_symbols),
                        onPressed: () {
                          _passwordController.text =
                              _generateRandomSecurePassword();
                        },
                      )
                    ]),
                validators: [Validator.required]),
            _TextFormField('Enter the secrets title/purpose...',
                prefix: Icon(Icons.short_text),
                validators: [Validator.required]),
            _TextFormField('Optional: Provide an username...',
                prefix: Icon(Icons.person)),
            _TextFormField('Optional: Provide an URL...',
                prefix: Icon(Icons.link)),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8, top: 8),
                    child: FlatButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        _showOnPopDialog(context);
                      },
                      child: Text("Cancel creation"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8, top: 8),
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
                          MessagingService.showSnackBarMessage(
                              context, 'Processing Data for $secret');
                        }
                      },
                      child: Text('Store secret'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }
}

class _TextFormField extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final String label;
  Widget suffix, prefix;
  List<Function> validators;
  bool obscureText = false;

  _TextFormField(this.label,
      {this.suffix,
      this.prefix,
      this.validators,
      this.controller,
      this.obscureText});

  String validate(String value) {
    for (final validator in validators) {
      return validator(value);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: TextFormField(
            obscureText: this.obscureText ?? false,
            onChanged: (value) {
              this.validate(value);
            },
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: prefix ?? prefix,
              suffixIcon: suffix ?? suffix,
            ),
            validator: (value) {
              return this.validate(value);
            },
          ),
        )
      ],
    );
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
