import 'package:lokr_ui/src/secret/domain/secret.dart';

class Bouncer extends Secret {
  Bouncer(String masterPassword) : super(password: masterPassword, title: 'bouncer', id: 'bouncer');
}
