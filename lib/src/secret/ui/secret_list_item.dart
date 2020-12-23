import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokr_ui/src/messaging_service.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/ui/secret_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class SecretListItem extends StatelessWidget {
  final Secret secret;

  SecretListItem(this.secret);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 4, bottom: 4),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: _ListItemTextView(
                text: secret.title,
              ),
            ),
            Expanded(
              child: _ListItemIconButtonView(
                  icon: Icons.vpn_key,
                  onPressAction: () {
                    FlutterClipboard.copy(this.secret.password).then((value) {
                      // Do what ever you want with the value.
                      MessagingService.showSnackBarMessage(
                          context, 'Password copied to clipboard');
                    });
                  }),
            ),
            Expanded(
              child: _ListItemIconButtonView(
                  icon: Icons.person,
                  onPressAction: this.secret.username.isNotEmpty
                      ? () {
                          FlutterClipboard.copy(this.secret.username)
                              .then((value) {
                            // Do what ever you want with the value.
                            MessagingService.showSnackBarMessage(
                                context, 'Username copied to clipboard');
                          });
                        }
                      : null),
            ),
            Expanded(
              child: _ListItemIconButtonView(
                  icon: Icons.link,
                  onPressAction: this.secret.url.isNotEmpty
                      ? () {
                          this._launchURL(this.secret.url, context);
                        }
                      : null),
            ),
            Expanded(
              child: _ListItemIconButtonView(
                  icon: Icons.edit,
                  onPressAction: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecretDetail(
                                secret: this.secret))).then((createdSecret) => {
                          if (createdSecret != null)
                            MessagingService.showSnackBarMessage(
                                context, 'Stored secret ${createdSecret.title}')
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String URL, BuildContext context) async {
    if (await canLaunch(URL)) {
      MessagingService.showSnackBarMessage(
          context, 'Opening URL ${this.secret.url}...');
      await launch(URL);
    } else {
      MessagingService.showSnackBarMessage(
          context, '${this.secret.url} is not a valid URL. Cannot open it.');
      throw '${this.secret.url} is not a valid URL. Cannot open it.';
    }
  }
}

class _ListItemTextView extends StatelessWidget {
  final String text;

  _ListItemTextView({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ListItemIconButtonView extends StatelessWidget {
  final IconData icon;
  final Function onPressAction;

  const _ListItemIconButtonView({Key key, this.icon, this.onPressAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: this.onPressAction, icon: Icon(this.icon));
  }
}
