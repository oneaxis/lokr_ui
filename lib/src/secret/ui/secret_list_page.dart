import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokr_ui/src/messaging_service.dart';
import 'package:lokr_ui/src/secret/blocs/secrets_bloc.dart';
import 'package:lokr_ui/src/secret/blocs/secrets_event.dart';
import 'package:lokr_ui/src/secret/blocs/secrets_state.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/ui/secret_detail_page.dart';
import 'package:lokr_ui/src/secret/ui/secret_list_item.dart';

class SecretListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SecretsBloc(),
      child: Scaffold(
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
                        text: 'Copy passwords with (',
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
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecretDetailPage.blank()))
                .then((createdSecret) => {
                      if (createdSecret != null)
                        MessagingService.showSnackBarMessage(
                            context, 'Stored secret ${createdSecret.title}')
                    });
          },
          tooltip: 'Create new secret',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class _RefreshableListView extends StatefulWidget {
  @override
  _RefreshableListViewState createState() => _RefreshableListViewState();
}

class _RefreshableListViewState extends State<_RefreshableListView> {
  @override
  Widget build(BuildContext context) {
    final SecretsBloc _secretsBloc = BlocProvider.of<SecretsBloc>(context);
    Future<void> _refreshState() async {
      _secretsBloc.add(SecretsFetchAll());
      return;
    }

    return RefreshIndicator(
        child: BlocBuilder<SecretsBloc, SecretsState>(
          builder: (context, state) {
            if (state is SecretsInitial)
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
            else if (state is SecretsFetchedAll) {
              return state.secrets.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                          "You don't have any stored secret yet. Create one first!",
                          style: Theme.of(context).textTheme.bodyText1))
                  : ListView(
                      shrinkWrap: true,
                      children:
                          state.secrets.map((e) => SecretListItem(e)).toList(),
                    );
            } else {
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
                            onPressed: _refreshState,
                            child: Text('Retry'),
                          )),
                    ],
                  ));
            }
          },
        ),
        onRefresh: _refreshState);
  }
}
