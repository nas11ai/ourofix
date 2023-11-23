import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:mobile/src/features/chat/domain/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_screen_controller.g.dart';

class ChatScreenController {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  ChatScreenController(this._firebaseAuth, this._firestore);

  TextEditingController get messageController => _messageController;

  Future<void> sendMessage({required String receiverId}) async {
    final String content = _messageController.text.trim();

    if (content.isNotEmpty) {
      final Message message = Message(
        senderId: _firebaseAuth.currentUser!.uid,
        receiverId: receiverId,
        content: content,
        sentTime: DateTime.now(),
        messageType: MessageType.text,
      );

      print('Mengirim pesan: $message');

      await _addMessageToFirestore(receiverId: receiverId, message: message);

      _messageController.clear();
    }
  }

  Future<void> _addMessageToFirestore({
    required String receiverId,
    required Message message,
  }) async {
    final tes = await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    print('tes: $tes');

    // Tampilkan dokumen yang baru saja ditambahkan
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await tes.get();
    print('Data dokumen baru: ${snapshot.data()}');
  }
}

@riverpod
ChatScreenController chatScreenController(ChatScreenControllerRef ref) {
  return ChatScreenController(
      ref.watch(firebaseAuthProvider), ref.watch(firebaseFirestoreProvider));
}
