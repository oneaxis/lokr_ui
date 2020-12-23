// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptionWrapper _$EncryptionWrapperFromJson(Map<String, dynamic> json) {
  return EncryptionWrapper(
    content: json['content'],
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$EncryptionWrapperToJson(EncryptionWrapper instance) =>
    <String, dynamic>{
      'content': instance.content,
      'id': instance.id,
    };
