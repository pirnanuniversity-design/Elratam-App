import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String sender;
  final String text;
  final Timestamp timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      sender: map['sender'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}
