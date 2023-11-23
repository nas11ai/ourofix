import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  // final String email;
  final String image;
  final String messagePreview;
  final DateTime lastActive;
  final bool isOnline;

  const User({
    required this.uid,
    required this.name,
    // required this.email,
    required this.image,
    required this.lastActive,
    this.messagePreview = '',
    this.isOnline = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json['uid'],
        name: json['displayName'],
        image: json['profilePictureUrl'],
        lastActive: (json['lastActive'] as Timestamp).toDate(),
        messagePreview: json['messagePreview'] ?? '',
        isOnline: json['isOnline'] ?? false,
      );
}
