import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:mobile/src/features/chat/domain/message.dart';
import 'package:mobile/src/features/chat/domain/user.dart' as model;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

class ChatRepository {
  ChatRepository(this._firestore, this._firebaseAuth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  // List<model.User> users = [];

  final ScrollController _scrollController = ScrollController();

  final StreamController<List<model.User>> _usersController =
      StreamController<List<model.User>>.broadcast();

  final StreamController<model.User?> _singleUserController =
      StreamController<model.User?>.broadcast();

  final StreamController<List<Message>> _messagesController =
      StreamController<List<Message>>.broadcast();

  ScrollController get scrollController => _scrollController;

  Stream<List<model.User>> get allUsers => _usersController.stream;

  Stream<model.User?> get userByUid => _singleUserController.stream;

  Stream<List<Message>> get allMessages => _messagesController.stream;

  void getAllUsers() {
    _firestore
        .collection('users')
        .orderBy('lastActive', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((querySnapshot) {
      final users = querySnapshot.docs
          .map((doc) => model.User.fromJson(doc.data()))
          .toList();
      _usersController.add(users);
    });
  }

  void getUserByUid({required String uid}) {
    _firestore
        .collection('users')
        .doc(uid)
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

  void getMessages({required String receiverId}) {
    _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        _messagesController.add([]);
      } else {
        final messages = querySnapshot.docs
            .map((doc) => Message.fromJson(doc.data()))
            .toList();
        _messagesController.add(messages);
      }
    });

    scrollDown();
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });

  void dispose() {
    _usersController.close();
    _singleUserController.close();
    _messagesController.close();
  }
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository(
      ref.watch(firebaseFirestoreProvider), ref.watch(firebaseAuthProvider));
}
