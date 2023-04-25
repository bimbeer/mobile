part of 'avatar_bloc.dart';

abstract class AvatarEvent extends Equatable {
  const AvatarEvent();

  @override
  List<Object> get props => [];
}

class AvatarChangeRequested extends AvatarEvent {
  const AvatarChangeRequested(this.imageSource);

  final ImageSource imageSource;
}
