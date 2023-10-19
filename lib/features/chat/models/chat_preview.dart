import 'package:bimbeer/features/chat/models/message.dart';
import 'package:equatable/equatable.dart';

class ChatPreview extends Equatable {
  final String pairId;
  final String name;
  final String avatarUrl;
  final Message? lastMessage;

  const ChatPreview(
      {required this.pairId,
      required this.name,
      required this.avatarUrl,
      this.lastMessage});

  ChatPreview copyWith({
    required String pairId,
    required String name,
    required String avatarUrl,
    required Message lastMessage,
  }) {
    return ChatPreview(
      pairId: this.pairId,
      name: this.name,
      avatarUrl: this.avatarUrl,
      lastMessage: this.lastMessage,
    );
  }

  @override
  List<Object?> get props => [pairId, name, avatarUrl, lastMessage];
}
