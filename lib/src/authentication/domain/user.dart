import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lokr_ui/src/authentication/domain/password.dart';
import 'package:lokr_ui/src/authentication/domain/username.dart';
import 'package:lokr_ui/src/encryption/encryptable.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable implements Encryptable {
  final Username username;
  final Password password;
  String id;

  User(this.username, this.password);

  @override
  List<Object> get props => [this.username, this.password, this.id];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
