part of 'onboard_bloc.dart';

abstract class OnboardState extends Equatable {
  const OnboardState();
  
  @override
  List<Object> get props => [];
}

class OnboardInitial extends OnboardState {}

class OnboardCreateAccount extends OnboardState {
  final route = '/create-account';

  @override
  List<Object> get props => [route];
}

class OnboardSignIn extends OnboardState {
  final route = '/sign-in';

  @override
  List<Object> get props => [route];
}
