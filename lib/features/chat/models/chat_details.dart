import 'package:bimbeer/features/chat/models/chat_preview.dart';
import 'package:bimbeer/features/chat/models/message.dart';
import 'package:equatable/equatable.dart';

class ChatDetails extends Equatable {
  final ChatPreview chatPreview;
  final List<Message> messages;

  const ChatDetails({required this.messages, required this.chatPreview});

  @override
  List<Object?> get props => [messages, chatPreview];
}
