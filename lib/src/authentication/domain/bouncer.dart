import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lokr_ui/src/encryption/encryptable.dart';
import 'package:lokr_ui/src/secret/domain/secret.dart';

part 'bouncer.g.dart';

@JsonSerializable()
class Bouncer extends Equatable implements Encryptable {
  String id;
  String masterPassword;

  Bouncer(this.id, this.masterPassword);

  factory Bouncer.fromJson(Map<String, dynamic> json) => _$BouncerFromJson(json);

  Map<String, dynamic> toJson() => _$BouncerToJson(this);

  @override
  List<Object> get props =>
      [this.id, this.masterPassword];

}
