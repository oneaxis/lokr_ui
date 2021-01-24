import 'package:lokr_ui/src/authentication/domain/bouncer.dart';

abstract class BouncerState {
  final Bouncer bouncer;

  BouncerState(this.bouncer);
}

abstract class BouncerErrorState extends BouncerState {
  final String error;

  BouncerErrorState(Bouncer bouncer, this.error) : super(bouncer);
}

class Initial extends BouncerState {
  Initial() : super(null);
}

class BouncerReady extends BouncerState {
  BouncerReady(Bouncer bouncer) : super(bouncer);
}

class BouncerAcceptedMasterPassword extends BouncerState {
  BouncerAcceptedMasterPassword(Bouncer bouncer) : super(bouncer);
}

class BouncerRejectedMasterPassword extends BouncerErrorState {
  BouncerRejectedMasterPassword(Bouncer bouncer, String error)
      : super(bouncer, error);
}

class BouncerNotFound extends BouncerErrorState {
  BouncerNotFound(String error) : super(null, error);
}

class CreateBouncerError extends BouncerErrorState {
  CreateBouncerError(String error) : super(null, error);
}

class BouncerKickOutSuccess extends BouncerState {
  BouncerKickOutSuccess(Bouncer bouncer) : super(bouncer);
}

class BouncerKickOutError extends BouncerState {
  BouncerKickOutError(Bouncer bouncer) : super(bouncer);
}
