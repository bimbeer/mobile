part of 'conversation_bloc.dart';

sealed class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class ConversationEntered extends ConversationEvent {
  const ConversationEntered({required this.chatIndex});

  final int chatIndex;

  @override
  List<Object> get props => [chatIndex];
}

class ConversationLeft extends ConversationEvent {
  const ConversationLeft();

  @override
  List<Object> get props => [];
}

class MessageSent extends ConversationEvent {
  const MessageSent(
      {required this.chatIndex,
      required this.text,
      required this.recipientId,
      required this.userId});

  final int chatIndex;
  final String text;
  final String recipientId;
  final String userId;

  @override
  List<Object> get props => [chatIndex, text, recipientId, userId];
}
