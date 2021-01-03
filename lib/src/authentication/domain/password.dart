import 'package:json_annotation/json_annotation.dart';

part 'password.g.dart';

@JsonSerializable()
class Password {
  final String value;

  Password(this.value);

  factory Password.fromJson(Map<String, dynamic> json) => _$PasswordFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordToJson(this);
}
