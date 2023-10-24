part of 'conversation_bloc.dart';

sealed class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

final class ConversationInitial extends ConversationState {}

final class ConversationLoaded extends ConversationState {
  const ConversationLoaded({required this.chatDetails});

  final ChatDetails chatDetails;

  @override
  List<Object> get props => [chatDetails];
}

final class ConversationLoading extends ConversationState {
  const ConversationLoading();

  @override
  List<Object> get props => [];
}
