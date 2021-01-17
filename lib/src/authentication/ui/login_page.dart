import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lokr_ui/src/authentication/bloc/authentication_bloc.dart';
import 'package:lokr_ui/src/authentication/bloc/authentication_event.dart';
import 'package:lokr_ui/src/authentication/bloc/authentication_state.dart';
import 'package:lokr_ui/src/authentication/domain/user.dart';
import 'package:lokr_ui/src/secret/ui/lokrui_text_form_field.dart';
import 'package:lokr_ui/src/secret/ui/secret_page_header.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordController = TextEditingController(),
      _titleController = TextEditingController(),
      _usernameController = TextEditingController(),
      _urlController = TextEditingController(),
      _descriptionController = TextEditingController();

  List<TextEditingController> _controllers = [];
  bool _isPasswordHidden = true;

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
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SecretPageHeader(
                title: tr('pages.login.title'),
                description: tr('pages.login.description'),
              ),
              LOKRUITextFormField(
                label: tr('pages.login.fields.username.label'),
                maxLength: 320,
                keyboardType: TextInputType.emailAddress,
                controller: _usernameController,
                prefix: Icon(Icons.person),
                validator: ValidationBuilder().maxLength(60).build(),
              ),
              LOKRUITextFormField(
                  label: tr('pages.login.fields.password.label'),
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
                      ]),
                  validator:
                      ValidationBuilder().minLength(3).maxLength(255).build()),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8, top: 8),
                      child: FlatButton(
                        onPressed: () {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            Registration(
                              username: _usernameController.text.trim(),
                              password: _passwordController.text.trim(),
                            ),
                          );
                        },
                        child: Text(
                          tr('pages.login.buttons.register.label'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8, top: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            LogIn(
                              User(
                                username: _usernameController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          tr('pages.login.buttons.login.label'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }, listener: (context, state) {
      print('New authentication state $state');
    });
  }

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  void _initControllers() {
    _controllers = [
      this._passwordController,
      this._titleController,
      this._usernameController,
      this._urlController
    ];
  }
}
