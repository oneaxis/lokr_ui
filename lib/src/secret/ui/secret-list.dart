import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokr_ui/src/messaging-service.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/ui/secret-detail.dart';
import 'package:lokr_ui/src/secret/ui/secret-list-item.dart';

import '../network/secret-api-service.dart';

class SecretList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('My stored secrets'),
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                  'Here you find all your stored secrets. Just click on one of the '
                  'fields (e.g. password) to copy the content or extend the secret details.',
                  style: Theme.of(context).textTheme.bodyText1),
              Divider(thickness: 1),
              Expanded(
                child: _ListView(),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecretDetail.blank()))
              .then((createdSecret) => {
                    if (createdSecret != null)
                      MessagingService.showSnackBarMessage(
                          context, 'Stored secret ${createdSecret.title}')
                  });
        },
        tooltip: 'Create new secret',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Secret>>(
      future: SecretAPIService.fetchAllSecrets(), // async work
      builder: (BuildContext context, AsyncSnapshot<List<Secret>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text('Loading stored secrets...',
                        style: Theme.of(context).textTheme.bodyText1),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: LinearProgressIndicator(),
                    )
                  ],
                ));
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data.isEmpty
                  ? Text(
                      "You don't have any stored secret yet. Create one first!",
                      style: Theme.of(context).textTheme.bodyText1)
                  : ListView(
                      shrinkWrap: true,
                      children:
                          snapshot.data.map((e) => SecretListItem(e)).toList(),
                    );
            }
        }
      },
    );
  }
}
