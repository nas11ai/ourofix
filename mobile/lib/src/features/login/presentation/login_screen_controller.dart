import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/src/features/login/data/login_repository.dart';

part 'login_screen_controller.g.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

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

@riverpod
class GoogleUser extends _$GoogleUser {
  @override
  GoogleSignInAccount? build() {
    return null;
  }

  void setAccount(GoogleSignInAccount? user) => state = user;

  GoogleSignInAccount? getAccount() => state;
}

@riverpod
FutureOr<UserCredential?> signInWithGoogle(SignInWithGoogleRef ref) async {
  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) {
    return null;
  }

  ref.read(googleUserProvider.notifier).setAccount(googleUser);

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await ref.read(firebaseAuthProvider).signInWithCredential(credential);
}
