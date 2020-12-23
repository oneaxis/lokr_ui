import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lokr_ui/src/messaging_service.dart';
import 'package:lokr_ui/src/secret/blocs/secret_bloc.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/resources/secret_repository.dart';
import 'package:lokr_ui/src/secret/ui/secret_detail.dart';
import 'package:lokr_ui/src/secret/ui/secret_list_item.dart';


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
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1,
                  children: [
                    TextSpan(
                      text:
                      'Copy passwords with (',
                    ),
                    WidgetSpan(
                      child: Icon(Icons.vpn_key, size: 14),
                    ),
                    TextSpan(
                      text: '), usernames with (',
                    ),
                    WidgetSpan(
                      child: Icon(Icons.person, size: 14),
                    ),
                    TextSpan(
                      text: '), open URLs with (',
                    ),
                    WidgetSpan(
                      child: Icon(Icons.link, size: 14),
                    ),
                    TextSpan(
                      text: ') or edit the secret details with (',
                    ),
                    WidgetSpan(
                      child: Icon(Icons.edit, size: 14),
                    ),
                    TextSpan(
                      text: ').',
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Divider(thickness: 1)),
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

  final _secretBloc = SecretBloc();

  Future<void> _refreshState() async {
    this._secretBloc.fetchAllSecrets();
    return;
  }

  @override
  void dispose() {
    this._secretBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._secretBloc.fetchAllSecrets();
    return RefreshIndicator(
        child: StreamBuilder<List<Secret>>(
          stream: _secretBloc.allSecrets,
          builder:
              (BuildContext context, AsyncSnapshot<List<Secret>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Padding(
                    padding: EdgeInsets.only(top: 8),
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
                      padding: EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          Text(
                              'Could not load stored secrets at the moment. '
                              'Please check your internet connection.',
                              style: Theme.of(context).textTheme.bodyText1),
                          Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: ElevatedButton(
                                onPressed: this._refreshState,
                                child: Text('Retry'),
                              )),
                        ],
                      ));
                } else {
                  return snapshot.data.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 8),
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
