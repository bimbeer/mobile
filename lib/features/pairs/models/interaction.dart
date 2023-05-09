import 'package:equatable/equatable.dart';

class Interaction extends Equatable {
  final String reactionType;
  final String recipient;
  final String sender;

  const Interaction({
    required this.reactionType,
    required this.recipient,
    required this.sender,
  });

  @override
  List<Object?> get props => [reactionType, recipient, sender];

  Interaction copyWith({
    String? reactionType,
    String? recipient,
    String? sender,
  }) {
    return Interaction(
      reactionType: reactionType ?? this.reactionType,
      recipient: recipient ?? this.recipient,
      sender: sender ?? this.sender,
    );
  }

  factory Interaction.fromJson(Map<String, dynamic> json) {
    return Interaction(
      reactionType: json['reactionType'],
      recipient: json['recipient'],
      sender: json['sender'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reactionType': reactionType,
      'recipient': recipient,
      'sender': sender,
    };
  }
}

