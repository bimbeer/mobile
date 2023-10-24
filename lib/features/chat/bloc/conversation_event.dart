part of 'conversation_bloc.dart';

sealed class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class ConversationEntered extends ConversationEvent {
  const ConversationEntered({required this.chatDetails});

  final ChatDetails chatDetails;

  @override
  List<Object> get props => [chatDetails];
}

class ConversationLeft extends ConversationEvent {
  const ConversationLeft();

  @override
  List<Object> get props => [];
}

class MessageSent extends ConversationEvent {
  const MessageSent({required this.message});

  final Message message;

  @override
  List<Object> get props => [message];
}
