import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SecretPageHeader extends StatelessWidget {
  final String title, description;

  const SecretPageHeader(
      {Key key, @required this.title, @required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      Text(
        description,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      Padding(
          padding: EdgeInsets.only(top: 8, bottom: 0),
          child: Divider(thickness: 1)),
    ]);
  }
}
