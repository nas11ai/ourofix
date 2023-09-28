import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/src/features/login/data/login_repository.dart';

part 'login_screen_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  Future<void> handleLogin(
      {required String username, required String password}) async {
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    final LoginRepository loginRepository = ref.watch(loginRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () async => await loginRepository.login(username, password));
  }
}
