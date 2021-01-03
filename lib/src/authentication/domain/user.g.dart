// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['username'] == null
        ? null
        : Username.fromJson(json['username'] as Map<String, dynamic>),
    json['password'] == null
        ? null
        : Password.fromJson(json['password'] as Map<String, dynamic>),
  )..id = json['id'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'id': instance.id,
    };
