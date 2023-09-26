import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus {
  pending,
  sent,
  delivered,
  read,
}

class Message {
  final String text;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;
  final String type;
  MessageStatus status;

  Message({
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.type,
    this.status = MessageStatus.pending,
  });

  // Factory constructor to convert from a Map to a Message object
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] as String,
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      type: map['type'] as String,
      status: MessageStatus.values[map['status'] as int],
    );
  }

  // Method to convert the Message object to a Map
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
      'type': type,
      'status': status.index,
    };
  }
}
