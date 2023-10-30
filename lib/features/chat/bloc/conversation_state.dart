part of 'conversation_bloc.dart';

sealed class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

final class ConversationInitial extends ConversationState {}

final class ConversationLoaded extends ConversationState {
  const ConversationLoaded({required this.chatIndex});

  final int chatIndex;

  @override
  List<Object> get props => [chatIndex];
}

final class ConversationLoading extends ConversationState {
  const ConversationLoading();

  @override
  List<Object> get props => [];
}
