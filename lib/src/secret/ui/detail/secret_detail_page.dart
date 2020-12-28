import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lokr_ui/src/messaging_service.dart';
import 'package:lokr_ui/src/secret/domain/secret_generator.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/resources/secret_repository.dart';
import 'package:lokr_ui/src/secret/ui/secret_page_header.dart';

import '../lokrui_text_form_field.dart';
import 'secret_optional_fields_expander.dart';

class SecretDetailPage extends StatelessWidget {
  final Secret secret;
  final bool isNewSecret;

  SecretDetailPage.createNew({Key key})
      : this.secret = Secret(),
        this.isNewSecret = true,
        super(key: key);

  SecretDetailPage.editExisting({Key key, this.secret})
      : this.isNewSecret = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(this.isNewSecret
            ? 'pages.detail.new.title'
            : 'pages.detail.edit.title')),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                SecretPageHeader(
                  title: tr(this.isNewSecret
                      ? 'pages.detail.new.body.title'
                      : 'pages.detail.edit.body.title'),
                  description: tr(this.isNewSecret
                      ? 'pages.detail.new.body.description'
                      : 'pages.detail.edit.body.description'),
                ),
                _SecretDetailForm(this.secret),
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
      _urlController = TextEditingController(),
      _descriptionController = TextEditingController();
  final Secret _initialSecret;
  List<TextEditingController> _controllers = [];
  bool _isPasswordHidden = true, _submitPressed = false, _isSubmitting = false;

  _SecretDetailFormState(this._initialSecret);

  @override
  void initState() {
    super.initState();
    this._initControllers();
  }

  @override
  void dispose() {
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
                LOKRUITextFormField(
                    label: tr('pages.detail.fields.password.label'),
                    obscureText: _isPasswordHidden,
                    autofocus: _passwordController.text.isEmpty,
                    controller: _passwordController,
                    maxLength: 255,
                    keyboardType: TextInputType.visiblePassword,
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
                              SecretGenerator.generateRandomPasswordStream()
                                  .listen((value) =>
                                      _passwordController.text = value);
                            },
                          )
                        ]),
                    validator: ValidationBuilder()
                        .minLength(3)
                        .maxLength(255)
                        .build()),
                LOKRUITextFormField(
                    label: tr('pages.detail.fields.purpose.label'),
                    autofocus: _titleController.text.isEmpty,
                    maxLength: 255,
                    prefix: Icon(Icons.short_text),
                    controller: _titleController,
                    validator: ValidationBuilder()
                        .minLength(3)
                        .maxLength(255)
                        .build()),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: SecretOptionalFieldsExpander(
                    urlController: this._urlController,
                    descriptionController: this._descriptionController,
                    usernameController: this._usernameController,
                  ),
                ),
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
                          child: Text(
                            tr('pages.detail.buttons.cancel.label'),
                          ),
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
                          child: Text(
                            tr('pages.detail.buttons.save.label'),
                          ),
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
            title: Text(
              tr('pages.detail.popDialog.title'),
              style: Theme.of(context).textTheme.headline6,
            ),
            content: Text(
              tr('pages.detail.popDialog.description'),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            actions: <Widget>[
              Row(
                children: [
                  FlatButton(
                      child:
                          Text(tr('pages.detail.popDialog.buttons.back.label')),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                  ElevatedButton(
                    child: Text(
                        tr('pages.detail.popDialog.buttons.continue.label')),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
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
        username: _usernameController.text,
        url: _urlController.text,
        description: _descriptionController.text);
  }

  void _validateAndStore(BuildContext context) {
    if (_formKey.currentState.validate()) {
      MessagingService.showSnackBarMessage(context, tr('pages.detail.snacks.storing'));

      SecretsRepository.storeSecret(this._getSecretFromForm())
          .then((Secret value) => {Navigator.of(context).pop(value)})
          .catchError((error) => {
                setState(() {
                  this._isSubmitting = false;
                }),
                MessagingService.showSnackBarMessage(
                    context, tr('pages.detail.snacks.error')),
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
