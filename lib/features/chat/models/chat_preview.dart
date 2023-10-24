import 'package:equatable/equatable.dart';

class ChatPreview extends Equatable {
  final String pairId;
  final String name;
  final String avatarUrl;

  const ChatPreview(
      {required this.pairId, required this.name, required this.avatarUrl});

  ChatPreview copyWith({
    String? pairId,
    String? name,
    String? avatarUrl,
  }) {
    return ChatPreview(
      pairId: pairId ?? this.pairId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [pairId, name, avatarUrl];
}
