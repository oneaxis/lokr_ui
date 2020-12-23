import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lokr_ui/src/messaging-service.dart';
import 'package:lokr_ui/src/secret/domain/secret-generator.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/network/secret-api-service.dart';

import 'secret-text-form-field.dart';

class SecretDetail extends StatefulWidget {
  final Secret secret;
  final isBlank;

  SecretDetail.blank({Key key})
      : this.secret = Secret(),
        this.isBlank = true,
        super(key: key);

  SecretDetail({Key key, this.secret})
      : this.isBlank = false,
        super(key: key);

  @override
  _SecretDetailState createState() =>
      _SecretDetailState(this.secret, this.isBlank);
}

class _SecretDetailState extends State<SecretDetail> {
  Secret _secret = Secret();
  String title;

  _SecretDetailState(this._secret, bool isBlank) {
    this.title = isBlank ? 'Create new secret' : 'Edit secret';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      TextSpan(
                        text:
                            'Type in your secret content. Use the secure password generator (',
                      ),
                      WidgetSpan(
                        child: Icon(Icons.emoji_symbols, size: 14),
                      ),
                      TextSpan(
                        text: ') to quickly create a new password.',
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Divider(thickness: 1)),
                _SecretDetailForm(this._secret),
              ],
            )),
      ),
    );
  }
}

class _SecretDetailForm extends StatefulWidget {
  final Secret secret;

  _SecretDetailForm(this.secret, {Key key}) : super(key: key);

  @override
  _SecretDetailFormState createState() => _SecretDetailFormState(this.secret);
}

class _SecretDetailFormState extends State<_SecretDetailForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController(),
      _titleController = TextEditingController(),
      _usernameController = TextEditingController(),
      _urlController = TextEditingController();

  List<TextEditingController> _controllers = [];

  bool _isPasswordHidden = true, _submitPressed = false, _isSubmitting = false;
  final Secret _initialSecret;

  _SecretDetailFormState(this._initialSecret);

  @override
  void initState() {
    super.initState();
    this._initControllers();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    this._controllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          this._popOnInitialStateOrShowDialog(context,
              this._initialSecret.hashCode, this._getSecretFromForm().hashCode);
          return false;
        },
        child: Form(
            autovalidateMode: this._submitPressed
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            key: _formKey,
            child: Column(
              children: [
                SecretTextFormField(
                    label: 'Your secret password...',
                    obscureText: _isPasswordHidden,
                    autofocus: _passwordController.text.isEmpty,
                    controller: _passwordController,
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
                              SecretGenerator.generateRandomPassword().then(
                                  (value) => _passwordController.text = value);
                            },
                          )
                        ]),
                    validator: ValidationBuilder()
                        .minLength(3)
                        .maxLength(255)
                        .build()),
                SecretTextFormField(
                    label: 'Enter the secrets title/purpose...',
                    autofocus: _titleController.text.isEmpty,
                    prefix: Icon(Icons.short_text),
                    controller: _titleController,
                    validator: ValidationBuilder()
                        .minLength(3)
                        .maxLength(255)
                        .build()),
                SecretTextFormField(
                  label: 'Optional: Provide an username...',
                  controller: _usernameController,
                  prefix: Icon(Icons.person),
                  validator: ValidationBuilder().maxLength(255).build(),
                ),
                SecretTextFormField(
                    label: 'Optional: Provide an URL...',
                    controller: _urlController,
                    validator: ValidationBuilder()
                        .or(
                            (builder) => builder.regExp(
                                RegExp(r'^$'), _urlController.text),
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
                            this._popOnInitialStateOrShowDialog(
                                context,
                                this._initialSecret.hashCode,
                                this._getSecretFromForm().hashCode);
                          },
                          child: Text("Cancel"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8, top: 8),
                        child: ElevatedButton(
                          onPressed: this._isSubmitting
                              ? null
                              : () {
                                  this._validateAndStore(context);
                                },
                          child: Text('Store secret'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  void _popOnInitialStateOrShowDialog(
      BuildContext context, int initialState, int newState) {
    if (initialState == newState) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Leaving secret editing?"),
            content: new Text("You have not stored your secret yet. "
                "If you go back, your changes will be lost."),
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
  }

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  Secret _getSecretFromForm() {
    return Secret(
        password: _passwordController.text,
        title: _titleController.text,
        username:
            _usernameController.text.isEmpty ? null : _usernameController.text,
        url: _urlController.text.isEmpty ? null : _urlController.text);
  }

  void _validateAndStore(BuildContext context) {
    if (_formKey.currentState.validate()) {
      MessagingService.showSnackBarMessage(context, 'Storing secret...');
      SecretAPIService.storeSecret(this._getSecretFromForm())
          .then((Secret value) => {Navigator.of(context).pop(value)})
          .catchError((error) => {
                setState(() {
                  this._isSubmitting = false;
                }),
                MessagingService.showSnackBarMessage(
                    context, 'Could not store secret at the moment'),
                throw error
              });

      setState(() {
        this._submitPressed = true;
        this._isSubmitting = true;
      });
    }
  }

  void _initControllers() {
    _controllers = [
      this._passwordController,
      this._titleController,
      this._usernameController,
      this._urlController
    ];

    this._passwordController.text = this._initialSecret.password;
    this._titleController.text = this._initialSecret.title;
    this._usernameController.text = this._initialSecret.username;
    this._urlController.text = this._initialSecret.url;
  }
}
