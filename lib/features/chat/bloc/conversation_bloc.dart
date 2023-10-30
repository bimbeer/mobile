import 'package:bimbeer/features/chat/data/repositories/message_repository.dart';
import 'package:bimbeer/features/chat/models/message.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc({required MessageRepository messageRepository})
      : _messageRepository = messageRepository,
        super(ConversationInitial()) {
    on<ConversationEntered>(_onChatRoomEntered);
    on<ConversationLeft>(_onChatRoomExit);
    on<MessageSent>(_onMessageSent);
  }
  final MessageRepository _messageRepository;

  void _onChatRoomEntered(
      ConversationEntered event, Emitter<ConversationState> emit) {
    emit(ConversationLoaded(chatIndex: event.chatIndex));
  }

  void _onChatRoomExit(
      ConversationLeft event, Emitter<ConversationState> emit) {
    emit(ConversationInitial());
  }

  void _onMessageSent(MessageSent event, Emitter<ConversationState> emit) {
    emit(const ConversationLoading());
    final message = Message(
        recipientId: event.recipientId,
        senderId: event.userId,
        text: event.text,
        timestamp: Timestamp.now(),
        status: 'sent');

    _messageRepository.addMessage(message);
    emit(ConversationLoaded(chatIndex: event.chatIndex));
  }
}
