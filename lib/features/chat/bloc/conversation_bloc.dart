import 'package:bimbeer/features/chat/data/repositories/message_repository.dart';
import 'package:bimbeer/features/chat/models/chat_details.dart';
import 'package:bimbeer/features/chat/models/message.dart';
import 'package:bloc/bloc.dart';
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
    emit(ConversationLoaded(chatDetails: event.chatDetails));
  }

  void _onChatRoomExit(
      ConversationLeft event, Emitter<ConversationState> emit) {
    emit(ConversationInitial());
  }

  void _onMessageSent(MessageSent event, Emitter<ConversationState> emit) {
    final chatDetails = (state as ConversationLoaded).chatDetails;
    final updatedChatDetails = chatDetails.copyWith(
      messages: [...chatDetails.messages, event.message],
    );

    _messageRepository.addMessage(event.message);
    emit(ConversationLoaded(chatDetails: updatedChatDetails));
  }
}
