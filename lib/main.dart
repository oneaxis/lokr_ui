import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lokr_ui/src/authentication/bloc/authentication_bloc.dart';
import 'package:lokr_ui/src/authentication/ui/login_page.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_bloc.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_event.dart';
import 'package:lokr_ui/src/secret/ui/list/secret_list_page.dart';
import 'package:flutter/widgets.dart';
import 'package:lokr_ui/src/storage_provider.dart';

Future main() async {
  await DotEnv().load('.env');

  WidgetsFlutterBinding.ensureInitialized();
  await EncryptionStorageProvider().initialize();

  runApp(
    EasyLocalization(
        supportedLocales: [const Locale('en', ''), const Locale('de', 'DE')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', ''),
        child: LOKRUI()),
  );
}

class LOKRUI extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SecretsBloc>(
          create: (context) => SecretsBloc()..add(LoadAllFromCache()),
        ),
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        )
      ],
      child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: tr('app.title'),
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: SecretListPage(),
          home: LoginPage()),
    );
  }
}
