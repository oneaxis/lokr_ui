import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LOKRUITextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget suffix, prefix;
  final validator;
  final bool obscureText, autofocus;
  final int maxLines, minLines, maxLength;
  final TextInputType keyboardType;

  const LOKRUITextFormField(
      {this.label,
      this.suffix,
      this.prefix,
      this.validator,
      this.controller,
      this.obscureText,
      this.autofocus,
      this.keyboardType,
      this.minLines,
      this.maxLength,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: TextFormField(
              style: Theme.of(context).textTheme.bodyText2,
              maxLines: this.maxLines ?? 1,
              minLines: this.minLines ?? 1,
              maxLength: this.maxLength,
              keyboardType: this.keyboardType ?? TextInputType.text,
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
