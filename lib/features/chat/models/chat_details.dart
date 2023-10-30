import 'package:bimbeer/features/chat/models/message.dart';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:equatable/equatable.dart';

class ChatDetails extends Equatable {
  final String pairUserId;
  final Profile pairProfile;
  final List<Message> messages;

  const ChatDetails({required this.pairUserId, required this.messages, required this.pairProfile});

  ChatDetails copyWith({
    String? pairUserId,
    Profile? pairProfile,
    List<Message>? messages,
  }) {
    return ChatDetails(
      pairUserId: pairUserId ?? this.pairUserId,
      messages: messages ?? this.messages,
      pairProfile: pairProfile ?? this.pairProfile,
    );
  }

  @override
  List<Object?> get props => [messages, pairProfile, pairUserId];
}
