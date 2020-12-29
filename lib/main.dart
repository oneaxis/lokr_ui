import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_bloc.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_event.dart';
import 'package:lokr_ui/src/secret/ui/list/secret_list_page.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(
    EasyLocalization(
        supportedLocales: [const Locale('en', ''), const Locale('de', 'DE')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', ''),
        assetLoader: YamlAssetLoader(),
        child: LOKRUI()),
  );
}

class LOKRUI extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SecretsBloc()..add(LoadAllFromCache()),
      child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: tr('app.title'),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SecretListPage()),
    );
  }
}
