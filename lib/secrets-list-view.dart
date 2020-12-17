import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokr_ui/messaging-service.dart';
import 'package:lokr_ui/secret.dart';
import 'package:lokr_ui/secrets-service.dart';

class SecretsListView extends StatefulWidget {
  final String title = 'Stored secrets';

  @override
  _SecretsListViewState createState() => _SecretsListViewState();
}

class _SecretsListViewState extends State<SecretsListView> {
  final List<Secret> _secrets = [];

  @override
  void initState() {
    super.initState();
    SecretsService()
        .getAllSecrets()
        .then((List<Secret> secrets) => this._updateSecrets(secrets));
  }

  void _addSecret(Secret secret) {
    this.setState(() {
      _secrets.add(secret);
    });
  }

  void _updateSecrets(List<Secret> secrets) {
    this.setState(() {
      _secrets.clear();
      _secrets.addAll(secrets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
                'Here you find all your stored secrets. Just click on one of the '
                'fields (e.g. password) to copy the content or extend the secret details.',
                style: Theme.of(context).textTheme.bodyText1),
            Divider(thickness: 1),
            Expanded(
              flex: 8,
              child: _ListView(_secrets),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this._addSecret(new Secret(
              password: 'somepassword',
              title: 'A new demo secret with long title...'));
        },
        tooltip: 'Create new secret',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<Secret> _secrets;

  @override
  Widget build(BuildContext context) {
    return _secrets.isEmpty
        ? Text("You don't have any stored secret yet. Create one first!",
            style: Theme.of(context).textTheme.bodyText1)
        : ListView(
            shrinkWrap: true,
            children: _secrets.map((e) => _ListItemView(e)).toList(),
          );
  }

  _ListView(this._secrets);
}

class _ListItemView extends StatelessWidget {
  final Secret secret;

  _ListItemView(this.secret);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8),
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
                        MessagingService.showSnackBarMessage(
                            context, 'Password copied to clipboard');
                      }),
                ),
                Expanded(
                  child: _ListItemIconButtonView(
                      icon: Icons.person,
                      onPressAction: () {
                        MessagingService.showSnackBarMessage(
                            context, 'Username copied to clipboard');
                      }),
                ),
                Expanded(
                  child: _ListItemIconButtonView(
                      icon: Icons.link,
                      onPressAction: () {
                        MessagingService.showSnackBarMessage(
                            context, 'URL copied to clipboard');
                      }),
                ),
                Expanded(
                  child: _ListItemIconButtonView(
                      icon: Icons.edit,
                      onPressAction: () {
                        MessagingService.showSnackBarMessage(
                            context, 'Loading editing view...');
                      }),
                ),
              ],
            )));
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
