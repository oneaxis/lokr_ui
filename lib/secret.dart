import 'package:json_annotation/json_annotation.dart';

part 'secret.g.dart';

@JsonSerializable()
class Secret {
  final String password, title;
  String username, url;

  Secret({this.password, this.title, this.url, this.username});
  factory Secret.fromJson(Map<String, dynamic> json) => _$SecretFromJson(json);
  Map<String, dynamic> toJson() => _$SecretToJson(this);
}
