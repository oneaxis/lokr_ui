import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lokr_ui/src/messaging-service.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';

import '../../lokrui-text-form-field.dart';

class SecretDetailView extends StatefulWidget {
  SecretDetailView({Key key}) : super(key: key);

  @override
  _SecretDetailViewState createState() => _SecretDetailViewState();
}

class _SecretDetailViewState extends State<SecretDetailView> {
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
                  _SecretDetailForm(),
                ],
              )),
        ),
      ),
    );
  }
}

class _SecretDetailForm extends StatefulWidget {
  @override
  _SecretDetailFormState createState() => _SecretDetailFormState();
}

class _SecretDetailFormState extends State<_SecretDetailForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'password': TextEditingController(),
    'title': TextEditingController(),
    'username': TextEditingController(),
    'url': TextEditingController(),
  };

  bool _isPasswordHidden = true;
  Secret editingSecret;
  Secret initialSecret = Secret();

  @override
  void initState() {
    editingSecret = Secret(
      password: _controllers['password'].text,
      title: _controllers['title'].text,
      username: _controllers['username'].text,
      url: _controllers['url'].text
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    for (var controller in this._controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          children: [
            LOKRUITextFormField(
                label: 'Your secret password...',
                obscureText: _isPasswordHidden,
                controller: _controllers['password'],
                prefix: Icon(Icons.vpn_key),
                suffix: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // added line
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: _isPasswordHidden
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          this.togglePasswordVisibility();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.emoji_symbols),
                        onPressed: () {
                          _controllers['password'].text =
                              _generateRandomSecurePassword();
                        },
                      )
                    ]),
                validator:
                    ValidationBuilder().minLength(3).maxLength(255).build()),
            LOKRUITextFormField(
                label: 'Enter the secrets title/purpose...',
                prefix: Icon(Icons.short_text),
                controller: _controllers['title'],
                validator:
                    ValidationBuilder().minLength(3).maxLength(255).build()),
            LOKRUITextFormField(
              label: 'Optional: Provide an username...',
              controller: _controllers['username'],
              prefix: Icon(Icons.person),
              validator: ValidationBuilder().maxLength(255).build(),
            ),
            LOKRUITextFormField(
                label: 'Optional: Provide an URL...',
                controller: _controllers['url'],
                validator: ValidationBuilder()
                    .or(
                        (builder) => builder.regExp(
                            RegExp(r'^$'), _controllers['url'].text),
                        (builder) => builder.url())
                    .build(),
                prefix: Icon(Icons.link)),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8, top: 8),
                    child: FlatButton(
                      onPressed: () {

                        // if (! (editingSecret == initialSecret)) //TODO: implement
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
                        if (_formKey.currentState.validate()) {
                          Secret secret = Secret(
                            password: _controllers['password'].text,
                            title: _controllers['title'].text,
                            username: _controllers['username'].text,
                            url: _controllers['url'].text,
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
