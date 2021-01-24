// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bouncer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bouncer _$BouncerFromJson(Map<String, dynamic> json) {
  return Bouncer(
    json['id'] as String,
    json['masterPassword'] as String,
  );
}

Map<String, dynamic> _$BouncerToJson(Bouncer instance) => <String, dynamic>{
      'id': instance.id,
      'masterPassword': instance.masterPassword,
    };
