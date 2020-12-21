import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LOKRUITextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget suffix, prefix;
  final validator;
  final bool obscureText;

  const LOKRUITextFormField(
      {this.label,
      this.suffix,
      this.prefix,
      this.validator,
      this.controller,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: TextFormField(
            obscureText: this.obscureText ?? false,
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: prefix,
              suffixIcon: suffix,
            ),
            validator: validator,
          ),
        )
      ],
    );
  }
}
