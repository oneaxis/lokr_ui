import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokr_ui/src/messaging_service.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/ui/detail/secret_detail_page.dart';
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
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ListItemTextView(
                      text: secret.title,
                    ),
                    if (secret.description != null &&
                        secret.description.isNotEmpty)
                      Text(
                        secret.description,
                        style: Theme.of(context).textTheme.caption,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: _ListItemIconButtonView(
                  icon: Icons.vpn_key,
                  onPressAction: () {
                    FlutterClipboard.copy(this.secret.password).then((value) {
                      // Do what ever you want with the value.
                      MessagingService.showSnackBarMessage(context,
                          tr('pages.list.body.secretList.actions.copy.password'));
                    });
                  }),
            ),
            Expanded(
              flex: 1,
              child: _ListItemIconButtonView(
                  icon: Icons.person,
                  onPressAction: this.secret.username != null &&
                          this.secret.username.isNotEmpty
                      ? () {
                          FlutterClipboard.copy(this.secret.username)
                              .then((value) {
                            // Do what ever you want with the value.
                            MessagingService.showSnackBarMessage(context,
                                tr('pages.list.body.secretList.actions.copy.username'));
                          });
                        }
                      : null),
            ),
            Expanded(
              flex: 1,
              child: _ListItemIconButtonView(
                  icon: Icons.link,
                  onPressAction:
                      this.secret.url != null && this.secret.url.isNotEmpty
                          ? () {
                              this._launchURL(context);
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
                            builder: (context) => SecretDetailPage.editExisting(
                                secret: this.secret))).then((createdSecret) => {
                          if (createdSecret != null)
                            MessagingService.showSnackBarMessage(
                              context,
                              tr('pages.list.snacks.stored',
                                  namedArgs: {'title': createdSecret.title}),
                            )
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context) async {
    if (await canLaunch(this.secret.url)) {
      MessagingService.showSnackBarMessage(
          context,
          tr('pages.list.body.secretList.actions.launch.url',
              namedArgs: {'url': this.secret.url}));
      await launch(this.secret.url);
    } else {
      String localizedErrorText =
          tr('validation.url.error', namedArgs: {'url': this.secret.url});
      MessagingService.showSnackBarMessage(context, localizedErrorText);
      throw localizedErrorText;
    }
  }
}

class _ListItemTextView extends StatelessWidget {
  final String text;

  _ListItemTextView({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText1,
      overflow: TextOverflow.ellipsis,
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
