import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth, this._firestore);
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }

  Future<bool> isUserExist({required String uid}) async {
    final userDoc = await _firestore.collection("users").doc(uid).get();

    return userDoc.exists;
  }

  Future<void> addNewUser({
    required String uid,
    String? displayName,
    String? profilePictureUrl,
    required String role,
  }) async {
    if (uid.isEmpty) {
      throw ArgumentError('UID tidak boleh kosong');
    }
    if (role.isEmpty) {
      throw ArgumentError('Role tidak boleh kosong');
    }

    final newUser = {
      "displayName": displayName,
      "profilePictureUrl": profilePictureUrl,
      "role": role,
      "updatedAt": FieldValue.serverTimestamp(),
    };

    await _firestore.collection("users").doc(uid).set(newUser);
  }
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
      ref.watch(firebaseAuthProvider), ref.watch(firebaseFirestoreProvider));
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
