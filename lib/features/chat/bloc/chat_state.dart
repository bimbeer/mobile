part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatListLoading extends ChatState {}

final class ChatListLoaded extends ChatState {
  const ChatListLoaded({required this.chatDetails});

  final List<ChatDetails> chatDetails;

  @override
  List<Object> get props => [chatDetails];
}

final class ChatListLoadingError extends ChatState {
  const ChatListLoadingError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
