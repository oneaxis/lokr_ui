import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'secret.g.dart';

@JsonSerializable()
class Secret extends Equatable {
  final String password, title, username, url, description;

  Secret(
      {this.password = '',
      this.title = '',
      this.username = '',
      this.url = '',
      this.description = ''});

  factory Secret.fromJson(Map<String, dynamic> json) => _$SecretFromJson(json);

  Map<String, dynamic> toJson() => _$SecretToJson(this);

  @override
  List<Object> get props =>
      [this.password, this.title, this.username, this.url, this.description];
}
