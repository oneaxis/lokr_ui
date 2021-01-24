import 'package:lokr_ui/src/authentication/domain/bouncer.dart';

abstract class BouncerEvent {
  BouncerEvent();
}

class GetLastActiveBouncer extends BouncerEvent {}

class HireBouncer extends BouncerEvent {
  Bouncer bouncer;

  HireBouncer(this.bouncer);
}

class KickUserOut extends BouncerEvent {}

class TellMasterPassword extends BouncerEvent {
  String masterPassword;

  TellMasterPassword(this.masterPassword) : super();
}
