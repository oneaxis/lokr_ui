import 'package:json_annotation/json_annotation.dart';

part 'encryption_wrapper.g.dart';

@JsonSerializable()
class EncryptionWrapper {
  final String encryptedContent, id;

  EncryptionWrapper({this.encryptedContent, this.id});
  factory EncryptionWrapper.fromJson(Map<String, dynamic> json) => _$EncryptionWrapperFromJson(json);
  Map<String, dynamic> toJson() => _$EncryptionWrapperToJson(this);
}
