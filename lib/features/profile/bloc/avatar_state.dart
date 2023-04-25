part of 'avatar_bloc.dart';

abstract class AvatarState extends Equatable {
  const AvatarState();
  
  @override
  List<Object> get props => [];
}

class AvatarInitial extends AvatarState { }

class AvatarUpdated extends AvatarState { }

class AvatarUpdateFailed extends AvatarState {
  const AvatarUpdateFailed(this.message);
  final String message;
}