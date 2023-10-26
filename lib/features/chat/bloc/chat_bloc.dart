import 'package:bimbeer/features/chat/data/repositories/message_repository.dart';
import 'package:bimbeer/features/chat/models/chat_details.dart';
import 'package:bimbeer/features/chat/models/chat_preview.dart';
import 'package:bimbeer/features/chat/models/message.dart';
import 'package:bimbeer/features/pairs/data/repositories/interactions_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
      {required ProfileRepository profileRepository,
      required InteractionsRepository interactionsRepository,
      required MessageRepository messageRepository})
      : _interactionsRepository = interactionsRepository,
        _profileRepository = profileRepository,
        _messageRepository = messageRepository,
        super(ChatInitial()) {
    on<ChatListFetched>(_onChatListFetched);
    on<ChatListUpdated>(_onChatListUpdated);
  }

  final ProfileRepository _profileRepository;
  final InteractionsRepository _interactionsRepository;
  final MessageRepository _messageRepository;

  void _onChatListFetched(
      ChatListFetched event, Emitter<ChatState> emit) async {
    emit(ChatListLoading());
    final userId = event.userId;
    final interactions =
        await _interactionsRepository.getAllInteractionsForUser(userId);

    final chatDetails = <ChatDetails>[];
    for (var interaction in interactions) {
      if (interaction.reactionType == 'like') {
        final pairId = interaction.sender == userId
            ? interaction.recipient
            : interaction.sender;

        if (chatDetails
            .any((element) => element.chatPreview.pairId == pairId)) {
          continue;
        }

        final messagesFromUser =
            await _messageRepository.getMessages(userId, pairId);
        final messagesFromPair =
            await _messageRepository.getMessages(pairId, userId);

        final messages = [...messagesFromUser, ...messagesFromPair];
        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        final pairProfile = await _profileRepository.get(pairId);

        final chatPreview = ChatPreview(
            pairId: pairId,
            name: pairProfile.username!,
            avatarUrl: pairProfile.avatar!);

        final detailedChat = ChatDetails(
          messages: messages,
          chatPreview: chatPreview,
        );

        chatDetails.add(detailedChat);
      }
    }
    emit(ChatListLoaded(chatDetails: chatDetails));
    _subscribeToMessages(event.userId, chatDetails);
  }

  void _onChatListUpdated(ChatListUpdated event, Emitter<ChatState> emit) {
    emit(ChatListLoading());
    emit(ChatListLoaded(chatDetails: event.chatDetails));
  }

  // TODO: add new chat details when new interaction is added
  void _subscribeToMessages(String userId, List<ChatDetails> chatDetails) {
    for (var detailedChat in chatDetails) {
      final pairId = detailedChat.chatPreview.pairId;

      Timestamp? lastMessageTimestamp = detailedChat.messages.isNotEmpty
          ? detailedChat.messages.last.timestamp
          : null;

      final sentByUser = _messageRepository.messagesStream(
          userId, pairId, lastMessageTimestamp);

      sentByUser.listen((messages) {
        if (messages.isNotEmpty) {
          _handleDetailedChatUpdate(messages, detailedChat);
          add(ChatListUpdated(chatDetails: chatDetails));
        }
      });

      final receivedByUser = _messageRepository.messagesStream(
          pairId, userId, lastMessageTimestamp);

      receivedByUser.listen((messages) {
        if (messages.isNotEmpty) {
          _handleDetailedChatUpdate(messages, detailedChat);
          add(ChatListUpdated(chatDetails: chatDetails));
        }
      });
    }
  }

  void _handleDetailedChatUpdate(
      List<Message> messages, ChatDetails detailedChat) {
    final lastMessage = messages.first;
    detailedChat.messages.add(lastMessage);
  }
}
