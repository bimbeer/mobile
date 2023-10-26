part of 'avatar_bloc.dart';

abstract class AvatarEvent extends Equatable {
  const AvatarEvent();

  @override
  List<Object> get props => [];
}

class AvatarChangeRequested extends AvatarEvent {
  const AvatarChangeRequested({required this.imageSource, required this.userId, required this.profile});

  final String userId;
  final Profile profile;
  final ImageSource imageSource;

  @override
  List<Object> get props => [userId, profile, imageSource];
}

class AvatarLoaded extends AvatarEvent {
  const AvatarLoaded(this.avatar);

  final String? avatar;
}
