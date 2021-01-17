import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lokr_ui/src/encryption/encryptable.dart';
import 'package:uuid/uuid.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable implements Encryptable {
  final String username;
  final String password;
  String id;

  factory User.create({String username, String password}) {
    return User(username: username, password: password, id: Uuid().v4());
  }

  User({this.username, this.password, this.id});

  @override
  List<Object> get props => [this.username, this.password, this.id];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
