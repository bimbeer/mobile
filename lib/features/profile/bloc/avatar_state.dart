part of 'avatar_bloc.dart';

enum AvatarStatus { initial, loading, loaded, updated, updateFailed }

class AvatarState extends Equatable {
  const AvatarState({this.avatar, required this.status, this.errorMessage});

  final AvatarStatus status;
  final String? avatar;
  final String? errorMessage;

  AvatarState copyWith({String? avatar, AvatarStatus? status, String? errorMessage}) {
    return AvatarState(
        avatar: avatar ?? this.avatar, status: status ?? this.status, 
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status];
}
