import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lokr_ui/src/authentication/bloc/bouncer_bloc.dart';
import 'package:lokr_ui/src/authentication/bloc/bouncer_events.dart';
import 'package:lokr_ui/src/authentication/bloc/bouncer_states.dart';
import 'package:lokr_ui/src/authentication/ui/login_page.dart';
import 'package:lokr_ui/src/authentication/ui/welcome_page.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_bloc.dart';
import 'package:lokr_ui/src/secret/bloc/secrets_event.dart';
import 'package:flutter/widgets.dart';
import 'package:lokr_ui/src/secret/ui/list/secret_list_page.dart';
import 'package:lokr_ui/src/encryption_storage_provider.dart';

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
          home: BlocBuilder<AuthenticationBloc, BouncerState>(
              builder: (context, state) {
            if (state is Initial) {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(GetLastActiveBouncer());
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: LinearProgressIndicator(),
                ),
              );
            } else if (state is BouncerReady ||
                state is BouncerRejectedMasterPassword) {
              return LoginPage();
            } else if (state is BouncerAcceptedMasterPassword) {
              return SecretListPage();
            } else {
              return WelcomePage();
            }
          })),
    );
  }
}
