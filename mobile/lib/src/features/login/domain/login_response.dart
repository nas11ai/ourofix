// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'code') required int code,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'data') @Default(null) LoginData? data,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
class LoginData with _$LoginData {
  const factory LoginData({
    @JsonKey(name: "type") required String type,
    @JsonKey(name: "attributes") required LoginAttribute attributes,
  }) = _LoginData;

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
}

@freezed
class LoginAttribute with _$LoginAttribute {
  const factory LoginAttribute({
    @JsonKey(name: "user_role") required String userRole,
    @JsonKey(name: "access_token") required String accessToken,
    @JsonKey(name: "refresh_token") required String refreshToken,
  }) = _LoginAttribute;

  factory LoginAttribute.fromJson(Map<String, dynamic> json) =>
      _$LoginAttributeFromJson(json);
}
