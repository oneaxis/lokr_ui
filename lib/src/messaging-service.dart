import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagingService {
  static void showSnackBarMessage(
      final BuildContext context, final String content) {
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
          SnackBar(content: Text(content), duration: Duration(seconds: 1)));
  }
}
