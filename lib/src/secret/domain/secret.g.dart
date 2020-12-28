// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Secret _$SecretFromJson(Map<String, dynamic> json) {
  return Secret(
    password: json['password'] as String,
    title: json['title'] as String,
    username: json['username'] as String,
    url: json['url'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$SecretToJson(Secret instance) => <String, dynamic>{
      'password': instance.password,
      'title': instance.title,
      'username': instance.username,
      'url': instance.url,
      'description': instance.description,
    };
