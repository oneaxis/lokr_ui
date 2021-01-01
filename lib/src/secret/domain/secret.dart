import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lokr_ui/src/encryption/encryptable.dart';
import 'package:uuid/uuid.dart';

part 'secret.g.dart';

@JsonSerializable()
class Secret extends Equatable implements Encryptable {
  final String password, title, username, url, description;
  String id;

  Secret(
      {String id,
      this.password = '',
      this.title = '',
      this.username = '',
      this.url = '',
      this.description = ''})
      : this.id = id ?? Uuid().v4();

  factory Secret.fromJson(Map<String, dynamic> json) => _$SecretFromJson(json);

  Map<String, dynamic> toJson() => _$SecretToJson(this);

  @override
  List<Object> get props =>
      [this.password, this.title, this.username, this.url, this.description];
}
