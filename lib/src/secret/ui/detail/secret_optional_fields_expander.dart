import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:lokr_ui/src/secret/ui/lokrui_text_form_field.dart';

class SecretOptionalFieldsExpander extends StatelessWidget {
  final TextEditingController usernameController,
      urlController,
      descriptionController;

  const SecretOptionalFieldsExpander(
      {Key key,
      this.usernameController,
      this.urlController,
      this.descriptionController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: EdgeInsets.only(bottom: 8),
      subtitle: Padding(
          padding: EdgeInsets.only(top: 4, bottom: 8),
          child: Text(
            tr('pages.detail.fields.optional.description'),
          )),
      tilePadding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      title: Text(tr('pages.detail.fields.optional.title'),
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      children: <Widget>[
        LOKRUITextFormField(
          label: tr('pages.detail.fields.username.label'),
          maxLength: 320,
          keyboardType: TextInputType.emailAddress,
          controller: usernameController,
          prefix: Icon(Icons.person),
          validator: ValidationBuilder().maxLength(60).build(),
        ),
        LOKRUITextFormField(
            label: tr('pages.detail.fields.url.label'),
            keyboardType: TextInputType.url,
            controller: urlController,
            maxLength: 200,
            validator: ValidationBuilder()
                .or(
                    (builder) =>
                        builder.regExp(RegExp(r'^$'), urlController.text),
                    (builder) => builder.url())
                .build(),
            prefix: Icon(Icons.link)),
        LOKRUITextFormField(
            label: tr('pages.detail.fields.description.label'),
            keyboardType: TextInputType.multiline,
            controller: descriptionController,
            validator: ValidationBuilder().maxLength(255).build(),
            maxLength: 255,
            minLines: 1,
            maxLines: 5,
            prefix: Icon(Icons.description)),
      ],
    );
  }
}
