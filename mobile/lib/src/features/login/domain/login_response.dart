import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @Default(null) LoginData? data,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
class LoginData with _$LoginData {
  const factory LoginData({
    required String type,
    required LoginAttribute attributes,
  }) = _LoginData;

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
}

@freezed
class LoginAttribute with _$LoginAttribute {
  const factory LoginAttribute({
    required String userRole,
    required String accessToken,
    required String refreshToken,
  }) = _LoginAttribute;

  factory LoginAttribute.fromJson(Map<String, dynamic> json) =>
      _$LoginAttributeFromJson(json);
}
