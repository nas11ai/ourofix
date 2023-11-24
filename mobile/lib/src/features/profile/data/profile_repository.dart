import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:mobile/src/features/chat/domain/user.dart' as model;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository(this._firestore, this._firebaseAuth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  final StreamController<model.User?> _singleUserController =
      StreamController<model.User?>.broadcast();

  Stream<model.User?> get currentUser => _singleUserController.stream;

  void getCurrentUser() {
    _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((querySnapshot) {
      if (querySnapshot.exists) {
        final user = model.User.fromJson(querySnapshot.data()!);
        _singleUserController.add(user);
      } else {
        _singleUserController.add(null);
      }
    });
  }

  Future<void> updateUserName(String newName) async {
    try {
      // Get current user
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({'displayName': newName});
      } else {
        throw Exception('Current user is null');
      }
    } catch (error) {
      print('Error updating user name: $error');
      throw Exception('Failed to update user name');
    }
  }

  void dispose() {
    _singleUserController.close();
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(_firebaseAuth.currentUser!.uid)
          .child('profile_picture.jpg');

      await storageRef.putFile(imageFile);

      final downloadURL = await storageRef.getDownloadURL();
      print('Download URL: $downloadURL');

      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({'profilePictureUrl': downloadURL});
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(
      ref.watch(firebaseFirestoreProvider), ref.watch(firebaseAuthProvider));
}
