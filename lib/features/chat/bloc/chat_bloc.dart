import 'package:bimbeer/features/chat/data/repositories/message_repository.dart';
import 'package:bimbeer/features/chat/models/chat_details.dart';
import 'package:bimbeer/features/chat/models/message.dart';
import 'package:bimbeer/features/pairs/data/repositories/interactions_repository.dart';
import 'package:bimbeer/features/pairs/models/interaction.dart';
import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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
    final checkedInteractions = List<Interaction>.empty(growable: true);

    final chatDetails = <ChatDetails>[];
    for (var interaction in interactions) {
      if (interaction.reactionType != 'like' ||
          checkedInteractions.contains(interaction)) {
        continue;
      }

      final userIsSender = interaction.sender == userId;
      final pairId = userIsSender ? interaction.recipient : interaction.sender;

      Interaction? counterInteraction;
      if (userIsSender) {
        counterInteraction = interactions.firstWhereOrNull((interaction) =>
            interaction.sender == pairId && interaction.recipient == userId);
      } else {
        counterInteraction = interactions.firstWhereOrNull((interaction) =>
            interaction.recipient == pairId && interaction.sender == userId);
      }

      if (counterInteraction == null ||
          checkedInteractions.contains(counterInteraction)) {
        checkedInteractions.add(interaction);
        continue;
      } else if (counterInteraction.reactionType != 'like') {
        checkedInteractions.add(interaction);
        checkedInteractions.add(counterInteraction);
        continue;
      }

      if (chatDetails.any((element) => element.pairUserId == pairId)) {
        continue;
      }

      final messagesFromUser =
          await _messageRepository.getMessages(userId, pairId);
      final messagesFromPair =
          await _messageRepository.getMessages(pairId, userId);

      final messages = [...messagesFromUser, ...messagesFromPair];
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      final pairProfile = await _profileRepository.get(pairId);

      final detailedChat = ChatDetails(
        pairUserId: pairId,
        messages: messages,
        pairProfile: pairProfile,
      );

      chatDetails.add(detailedChat);
    }
    emit(ChatListLoaded(chatDetails: chatDetails));
    _subscribeToInteractions(event.userId, chatDetails);
    _subscribeToMessages(event.userId, chatDetails);
  }

  void _onChatListUpdated(ChatListUpdated event, Emitter<ChatState> emit) {
    emit(ChatListLoading());
    emit(ChatListLoaded(chatDetails: event.chatDetails));
  }

  void _subscribeToMessages(String userId, List<ChatDetails> chatDetails) {
    for (var detailedChat in chatDetails) {
      final pairId = detailedChat.pairUserId;

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

  void _subscribeToInteractions(String userId, List<ChatDetails> chatDetails) {
    _interactionsRepository
        .streamGetAllInteractionsForUser(userId)
        .listen((interactions) async {
      if (interactions.isNotEmpty) {
        final newInteraction = interactions.last;
        if (newInteraction.reactionType == 'like') {
          final userIsSender = newInteraction.sender == userId;
          final counterInteraction = interactions.firstWhereOrNull(
              (interaction) =>
                  interaction.sender == newInteraction.recipient &&
                  interaction.recipient == newInteraction.sender);
          if (counterInteraction != null &&
              counterInteraction.reactionType == 'like') {
            final pairId =
                userIsSender ? newInteraction.recipient : newInteraction.sender;
            if (!chatDetails.any((element) => element.pairUserId == pairId)) {
              final pairProfile = await _profileRepository.get(pairId);
              final detailedChat = ChatDetails(
                  pairUserId: pairId,
                  messages: List<Message>.empty(growable: true),
                  pairProfile: pairProfile);
              chatDetails = [...chatDetails, detailedChat];
              add(ChatListUpdated(chatDetails: chatDetails));

              final sentByUser =
                  _messageRepository.messagesStream(userId, pairId);

              sentByUser.listen((messages) {
                if (messages.isNotEmpty) {
                  _handleDetailedChatUpdate(messages, detailedChat);
                  add(ChatListUpdated(chatDetails: chatDetails));
                }
              });

              final receivedByUser =
                  _messageRepository.messagesStream(pairId, userId);

              receivedByUser.listen((messages) {
                if (messages.isNotEmpty) {
                  _handleDetailedChatUpdate(messages, detailedChat);
                  add(ChatListUpdated(chatDetails: chatDetails));
                }
              });
            }
          }
        }
      }
    });
  }

  void _handleDetailedChatUpdate(
      List<Message> messages, ChatDetails detailedChat) {
    final lastMessage = messages.first;
    detailedChat.messages.add(lastMessage);
  }
}
