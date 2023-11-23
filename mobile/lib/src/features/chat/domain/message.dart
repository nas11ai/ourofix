import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sentTime;
  final MessageType messageType;

  const Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sentTime,
    required this.messageType,
  });

  Map<String, dynamic> toJson() => {
        'receiverId': receiverId,
        'senderId': senderId,
        'sentTime': sentTime,
        'content': content,
        'messageType': messageType.toJson(),
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        content: json['content'],
        sentTime: (json['sentTime'] as Timestamp).toDate(),
        messageType: _parseMessageType(json['messageType']),
      );

  static MessageType _parseMessageType(dynamic jsonValue) {
    if (jsonValue is String) {
      return MessageType.values.firstWhere((e) => e.name == jsonValue,
          orElse: () => MessageType.text);
    } else {
      return MessageType.text;
    }
  }
}

enum MessageType {
  text,
  image;

  String toJson() => name;
}
