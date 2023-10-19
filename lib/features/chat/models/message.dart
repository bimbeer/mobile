import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String recipientId;
  final String senderId;
  final String text;
  final String status;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.recipientId,
    required this.senderId,
    required this.text,
    required this.status,
    required this.timestamp,
  });

  Message copyWith({
    String? id,
    String? recipientId,
    String? senderId,
    String? text,
    String? status,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      recipientId: recipientId ?? this.recipientId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pairId': recipientId,
      'uid': senderId,
      'text': text,
      'status': status,
      'createdAt': timestamp,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      recipientId: json['pairId'],
      senderId: json['uid'],
      text: json['text'],
      status: json['status'],
      timestamp: json['createdAt'],
    );
  }

  @override
  List<Object?> get props => [id, recipientId, senderId, text, status, timestamp];
}
