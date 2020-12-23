import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecretTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget suffix, prefix;
  final validator;
  final bool obscureText, autofocus;

  const SecretTextFormField(
      {this.label,
      this.suffix,
      this.prefix,
      this.validator,
      this.controller,
      this.obscureText,
      this.autofocus});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: TextFormField(
              autofocus: this.autofocus ?? false,
              obscureText: this.obscureText ?? false,
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: label,
                prefixIcon: prefix,
                suffixIcon: suffix,
              ),
              validator: validator,
            ),
          )
        ],
      ),
    );
  }
}
