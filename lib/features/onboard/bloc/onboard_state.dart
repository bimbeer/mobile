part of 'onboard_bloc.dart';

abstract class OnboardState extends Equatable {
  const OnboardState();
  
  @override
  List<Object> get props => [];
}

class OnboardInitial extends OnboardState {}

class OnboardCreateAccount extends OnboardState {
  final route = AppRoute.createAccount;

  @override
  List<Object> get props => [route];
}

class OnboardSignIn extends OnboardState {
  final route = AppRoute.signIn;

  @override
  List<Object> get props => [route];
}
