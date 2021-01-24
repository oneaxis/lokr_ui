import 'package:json_annotation/json_annotation.dart';

part 'encryption_wrapper.g.dart';

@JsonSerializable()
class EncryptionWrapper {
  final String encryptedContent, id;
  final DateTime createdAt;
  DateTime updatedAt;

  EncryptionWrapper(
      {this.encryptedContent, this.id, DateTime createdAt, DateTime updatedAt})
      : this.createdAt = createdAt ?? DateTime.now(),
        this.updatedAt = updatedAt ?? DateTime.now();

  factory EncryptionWrapper.fromJson(Map<String, dynamic> json) =>
      _$EncryptionWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptionWrapperToJson(this);
}
