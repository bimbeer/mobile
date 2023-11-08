import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Interaction extends Equatable {
  final String reactionType;
  final String recipient;
  final String sender;
  final Timestamp timestamp;

  const Interaction({
    required this.reactionType,
    required this.recipient,
    required this.sender,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [reactionType, recipient, sender, timestamp];

  Interaction copyWith({
    String? reactionType,
    String? recipient,
    String? sender,
    Timestamp? timestamp,
  }) {
    return Interaction(
      reactionType: reactionType ?? this.reactionType,
      recipient: recipient ?? this.recipient,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory Interaction.fromJson(Map<String, dynamic> json) {
    return Interaction(
      reactionType: json['reactionType'],
      recipient: json['recipient'],
      sender: json['sender'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reactionType': reactionType,
      'recipient': recipient,
      'sender': sender,
      'timestamp': timestamp,
    };
  }
}
