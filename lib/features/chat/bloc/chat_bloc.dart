import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bimbeer/features/chat/data/repositories/message_repository.dart';
import 'package:bimbeer/features/chat/models/chat_details.dart';
import 'package:bimbeer/features/chat/models/chat_preview.dart';
import 'package:bimbeer/features/pairs/data/repositories/interactions_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
      {required AuthenticaionRepository authenticationRepository,
      required ProfileRepository profileRepository,
      required InteractionsRepository interactionsRepository,
      required MessageRepository messageRepository})
      : _authenticationRepository = authenticationRepository,
        _interactionsRepository = interactionsRepository,
        _profileRepository = profileRepository,
        _messageRepository = messageRepository,
        super(ChatInitial()) {
    on<ChatListFetched>(_onChatListFetched);
    on<ChatListUpdated>(_onChatListUpdated);
    on<ChatRoomEntered>(_onChatRoomEntered);
  }

  final AuthenticaionRepository _authenticationRepository;
  final ProfileRepository _profileRepository;
  final InteractionsRepository _interactionsRepository;
  final MessageRepository _messageRepository;

  void _onChatListFetched(
      ChatListFetched event, Emitter<ChatState> emit) async {
    emit(ChatListLoading());
    final userId = _authenticationRepository.currentUser.id;
    final interactions =
        await _interactionsRepository.getAllInteractionsForUser(userId);

    final chatDetails = <ChatDetails>[];
    for (var interaction in interactions) {
      if (interaction.reactionType == 'like') {
        final pairId = interaction.sender == userId
            ? interaction.recipient
            : interaction.sender;

        final messagesFromUser =
            await _messageRepository.getMessages(userId, pairId);
        final messagesFromPair =
            await _messageRepository.getMessages(pairId, userId);

        final messages = [...messagesFromUser, ...messagesFromPair];
        messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        final pairProfile = await _profileRepository.get(pairId);

        final chatPreview = ChatPreview(
            pairId: pairId,
            name: pairProfile.username!,
            avatarUrl: pairProfile.avatar!,
            lastMessage: messages.isNotEmpty ? messages.first : null);

        final detailedChat = ChatDetails(
          messages: messages,
          chatPreview: chatPreview,
        );

        chatDetails.add(detailedChat);
      }
    }
    emit(ChatListLoaded(chatDetails: chatDetails));
    _subscribeToMessages(chatDetails);
  }

  void _onChatListUpdated(ChatListUpdated event, Emitter<ChatState> emit) {
    emit(ChatListLoaded(chatDetails: event.chatDetails));
  }

  // TODO: add new chat details when new interaction is added
  void _subscribeToMessages(List<ChatDetails> chatDetails) {
    final userId = _authenticationRepository.currentUser.id;

    for (var deatiledChat in chatDetails) {
      final pairId = deatiledChat.chatPreview.pairId;

      final sentByUser = _messageRepository.messagesStream(userId, pairId);

      sentByUser.listen((event) {
        deatiledChat.messages.addAll(event);
        add(ChatListUpdated(chatDetails: chatDetails));
      });

      final receivedByUser = _messageRepository.messagesStream(pairId, userId);

      receivedByUser.listen((event) {
        deatiledChat.messages.addAll(event);
        add(ChatListUpdated(chatDetails: chatDetails));
      });
    }
  }

  void _onChatRoomEntered(ChatRoomEntered event, Emitter<ChatState> emit) {
    emit(ChatRoomLoaded(chatDetails: event.chatDetails));
  }
}
