import 'package:json_annotation/json_annotation.dart';

part 'secret.g.dart';

@JsonSerializable()
class Secret {
  final String password, title;
  String username, url;

  Secret({this.password, this.title, String url, String username}) {
    // Add defaults for null safety
    this.url = url ?? '';
    this.username = username ?? '';
  }

  factory Secret.fromJson(Map<String, dynamic> json) => _$SecretFromJson(json);

  Map<String, dynamic> toJson() => _$SecretToJson(this);

  @override
  String toString() {
    return 'Secret{password: $password, title: $title, username: $username, url: $url}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Secret &&
          runtimeType == other.runtimeType &&
          password == other.password &&
          title == other.title &&
          username == other.username &&
          url == other.url;

  @override
  int get hashCode =>
      password.hashCode ^ title.hashCode ^ username.hashCode ^ url.hashCode;
}
