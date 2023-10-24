part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatListFetched extends ChatEvent {
  const ChatListFetched();

  @override
  List<Object> get props => [];
}

class ChatListUpdated extends ChatEvent {
  const ChatListUpdated({required this.chatDetails});

  final List<ChatDetails> chatDetails;

  @override
  List<Object> get props => [chatDetails];
}
