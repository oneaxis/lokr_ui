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
        body: Padding(
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

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            _PasswordFormField(),
            _TextFormField('Enter the secrets title/purpose...',
                prefix: Icon(Icons.edit), validators: [Validator.required]),
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
}

class _TextFormField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final String label;
  Icon suffix, prefix;
  List<Function> validators;

  _TextFormField(this.label, {this.suffix, this.prefix, this.validators});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: prefix ?? prefix,
              suffixIcon: suffix ?? suffix,
            ),
            validator: (value) {
              for (final validator in validators) {
                return validator(value);
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}

class _PasswordFormField extends StatefulWidget {
  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<_PasswordFormField> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void togglePasswordVisibility() {
    this.setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: TextFormField(
            obscureText: !_isPasswordVisible,
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: 'Your secret password...',
                prefixIcon: Icon(Icons.vpn_key),
                suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // added line
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: _isPasswordVisible
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
                    ])),
            validator: (value) {
              if (value.isEmpty) {
                return 'A password is required!';
              }
              return null;
            },
          ),
        ),
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
