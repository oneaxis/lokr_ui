import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lokr_ui/src/authentication/bloc/bouncer_bloc.dart';
import 'package:lokr_ui/src/authentication/bloc/bouncer_events.dart';
import 'package:lokr_ui/src/authentication/bloc/bouncer_states.dart';
import 'package:lokr_ui/src/authentication/domain/bouncer.dart';
import 'package:lokr_ui/src/messaging_service.dart';
import 'package:lokr_ui/src/secret/ui/lokrui_text_form_field.dart';
import 'package:lokr_ui/src/secret/ui/secret_page_header.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordHidden = true, _submitPressed = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, BouncerState>(
          builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Form(
            key: _formKey,
            autovalidateMode: this._submitPressed
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SecretPageHeader(
                  title: tr('pages.login.title'),
                  description: tr('pages.login.description'),
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
                    validator: ValidationBuilder()
                        .minLength(3)
                        .maxLength(255)
                        .build()),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8, top: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            this._submitPressed = true;
                            BlocProvider.of<AuthenticationBloc>(context).add(
                              TellMasterPassword(
                                _passwordController.text.trim(),
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
        if (state is BouncerRejectedMasterPassword)
          MessagingService.showSnackBarMessage(
              context, tr('validation.bouncerRejectedPassword.error'));
      }),
    );
  }

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }
}
