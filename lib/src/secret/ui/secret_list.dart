import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokr_ui/src/messaging_service.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/ui/secret_detail.dart';
import 'package:lokr_ui/src/secret/ui/secret_list_item.dart';

import '../network/secret_api_service.dart';

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
                child: _RefreshableListView(),
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

class _RefreshableListView extends StatefulWidget {
  @override
  _RefreshableListViewState createState() => _RefreshableListViewState();
}

class _RefreshableListViewState extends State<_RefreshableListView> {
  Future<void> _refreshState() async {
    setState(() {});
    return Future(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: FutureBuilder<List<Secret>>(
          future: SecretAPIService.fetchAllSecrets(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Secret>> snapshot) {
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
                  return Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Could not load stored secrets at the moment',
                          style: Theme.of(context).textTheme.bodyText1));
                } else {
                  return snapshot.data.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                              "You don't have any stored secret yet. Create one first!",
                              style: Theme.of(context).textTheme.bodyText1))
                      : ListView(
                          shrinkWrap: true,
                          children: snapshot.data
                              .map((e) => SecretListItem(e))
                              .toList(),
                        );
                }
            }
          },
        ),
        onRefresh: this._refreshState);
  }
}
