import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokr_ui/src/messaging_service.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_bloc.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_event.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_state.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';
import 'package:lokr_ui/src/secret/ui/detail/secret_detail_page.dart';
import 'package:lokr_ui/src/secret/ui/list/secret_list_item.dart';
import 'package:lokr_ui/src/secret/ui/lokrui_text_form_field.dart';
import 'package:lokr_ui/src/secret/ui/secret_page_header.dart';

class SecretListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          children: [
            Icon(Icons.security),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 10,
              child: Text(tr('pages.list.title')),
            ),
          ],
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecretPageHeader(
                  title: tr('pages.list.body.title'),
                  description: tr('pages.list.body.description')),
              Expanded(
                child: _RefreshableListView(),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return SecretDetailPage.createNew();
          }));
        },
        tooltip: tr('pages.list.buttons.create.tooltip'),
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
  String _filterPattern = '';
  final TextEditingController _searchController = TextEditingController();

  void _onSearchUpdate() {
    print('on search update');
    setState(() {
      _filterPattern = _searchController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    this._searchController.addListener(_onSearchUpdate);
  }

  @override
  void dispose() {
    this._searchController.dispose();
    super.dispose();
  }

  bool _matchesFilterPattern(Secret secret) {
    if (secret == null) return false;

    return (secret.title
            .toLowerCase()
            .contains(this._filterPattern.toLowerCase()) ||
        (secret.description != null &&
            secret.description
                .toLowerCase()
                .contains(this._filterPattern.toLowerCase())));
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshState() async {
      BlocProvider.of<SecretsBloc>(context).add(LoadAllFromCache());
      return;
    }

    _refreshState();

    return Column(
      children: [
        LOKRUITextFormField(
            label: tr('pages.list.body.search.label'),
            prefix: Icon(Icons.search),
            suffix: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.text = '';
              },
            ),
            controller: this._searchController),
        Expanded(
          child: RefreshIndicator(
              child: BlocConsumer<SecretsBloc, SecretsState>(
                listener: (context, state) {
                  if (state is SaveSingleToCacheSuccess) {
                    MessagingService.showSnackBarMessage(
                      context,
                      tr(
                        'pages.list.snacks.stored',
                        namedArgs: {'title': '${state.subject.title}'},
                      ),
                    );
                  }
                  else if (state is DeleteSingleFromCacheSuccess) {
                    MessagingService.showSnackBarMessage(
                      context,
                      tr(
                        'pages.list.snacks.deleted',
                        namedArgs: {'title': '${state.subject.title}'},
                      ),
                    );
                  } else if (state is DeleteSingleFromCacheError) {
                    MessagingService.showSnackBarMessage(
                      context,
                      tr(
                        'pages.list.snacks.deletionError',
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is Initial) {
                    return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Text(tr('pages.list.body.secretList.loading'),
                                style: Theme.of(context).textTheme.bodyText2),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: LinearProgressIndicator(),
                            )
                          ],
                        ));
                  } else if (state is LoadAllFromCacheSuccess ||
                      state is SecretStateSingleSuccess) {
                    final List<SecretListItem> filteredListItems = state.secrets
                        .where(_matchesFilterPattern)
                        .map((e) => SecretListItem(e))
                        .toList();

                    if (state.secrets.isEmpty)
                      return Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(tr('pages.list.body.secretList.empty'),
                              style: Theme.of(context).textTheme.bodyText2));
                    else if (filteredListItems.isEmpty) {
                      return Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(tr('pages.list.body.search.noResult'),
                              style: Theme.of(context).textTheme.bodyText2));
                    } else {
                      return ListView(
                        shrinkWrap: true,
                        children: filteredListItems,
                      );
                    }
                  } else {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Text(tr('pages.list.body.secretList.error'),
                                style: Theme.of(context).textTheme.bodyText2),
                            Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: ElevatedButton(
                                  onPressed: () => {
                                    BlocProvider.of<SecretsBloc>(context)
                                        .add(SyncWithAPI())
                                  },
                                  child: Text(
                                      tr('pages.list.body.secretList.retry')),
                                )),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              onRefresh: _refreshState),
        ),
      ],
    );
  }
}
