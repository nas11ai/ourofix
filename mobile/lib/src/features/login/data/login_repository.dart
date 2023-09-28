import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile/src/features/login/application/login_service.dart';
import 'package:mobile/src/features/login/domain/login_request.dart';
import 'package:mobile/src/features/login/domain/login_response.dart';

part 'login_repository.g.dart';

class LoginRepository {
  final LoginService _loginService;

  LoginRepository(this._loginService);

  Future<LoginResponse> login(String username, String password) async =>
      await _loginService.login(LoginRequest(
        username: username,
        password: password,
      ));
}

@Riverpod(keepAlive: true)
LoginRepository loginRepository(LoginRepositoryRef ref) {
  return LoginRepository(LoginService(Dio(BaseOptions(
    contentType: "application/json",
  ))));
}
