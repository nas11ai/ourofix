import 'dart:async';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:mobile/src/constants/api.dart';
import 'package:mobile/src/features/login/domain/login_request.dart';
import 'package:mobile/src/features/login/domain/login_response.dart';

part 'login_service.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class LoginService {
  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;

  @POST("/users/login")
  Future<LoginResponse> login(@Body() LoginRequest request);
}
