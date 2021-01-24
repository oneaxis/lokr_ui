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

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  final _masterPasswordController = TextEditingController(),
      _lokrNameController = TextEditingController();

  bool _isPasswordHidden = true, _submitPressed = false;

  @override
  void dispose() {
    _masterPasswordController.dispose();
    _lokrNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthenticationBloc, BouncerState>(
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
                    title: tr('pages.welcome.title'),
                    description: tr('pages.welcome.description'),
                  ),
                  LOKRUITextFormField(
                    label: tr('pages.welcome.fields.lokrName.label'),
                    maxLength: 320,
                    keyboardType: TextInputType.text,
                    controller: _lokrNameController,
                    prefix: Icon(Icons.person),
                    validator:
                        ValidationBuilder().minLength(3).maxLength(60).build(),
                  ),
                  LOKRUITextFormField(
                      label: tr('pages.welcome.fields.password.label'),
                      obscureText: _isPasswordHidden,
                      autofocus: _masterPasswordController.text.isEmpty,
                      controller: _masterPasswordController,
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
                                HireBouncer(
                                  Bouncer(_lokrNameController.text.trim(),
                                      _masterPasswordController.text.trim()),
                                ),
                              );
                            },
                            child: Text(
                              tr('pages.welcome.buttons.create.label'),
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
        },
      ),
    );
  }

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }
}
