// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption_wrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptionWrapper _$EncryptionWrapperFromJson(Map<String, dynamic> json) {
  return EncryptionWrapper(
    encryptedContent: json['encryptedContent'] as String,
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
  );
}

Map<String, dynamic> _$EncryptionWrapperToJson(EncryptionWrapper instance) =>
    <String, dynamic>{
      'encryptedContent': instance.encryptedContent,
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
