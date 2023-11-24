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
Future<void> signInWithGoogle(SignInWithGoogleRef ref) async {
  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) {
    throw Exception("User Google tidak ditemukan");
  }

  ref.read(googleUserProvider.notifier).setAccount(googleUser);

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final UserCredential userCredential =
      await ref.read(firebaseAuthProvider).signInWithCredential(credential);

  final isUserExist = await ref
      .read(authRepositoryProvider)
      .isUserExist(uid: userCredential.user!.uid);

  String? token =
      await ref.read(firebaseAuthProvider).currentUser!.getIdToken(true);

  while (token != null && token.length > 0) {
    int initLength = (token.length >= 500 ? 500 : token.length);
    print(token.substring(0, initLength));
    int endLength = token.length;
    token = token.substring(initLength, endLength);

    if (token.isEmpty) {
      break;
    }
  }

  if (!isUserExist) {
    await ref.read(authRepositoryProvider).addNewUser(
          uid: userCredential.user!.uid,
          displayName: userCredential.user!.displayName,
          profilePictureUrl: userCredential.user!.photoURL,
          role: 'User',
        );
  }
}
