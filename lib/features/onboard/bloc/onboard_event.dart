part of 'onboard_bloc.dart';

abstract class OnboardEvent extends Equatable {
  const OnboardEvent();

  @override
  List<Object> get props => [];
}

class OnboardCreateAccountPressed extends OnboardEvent { }

class OnboardSignInPressed extends OnboardEvent { }

class OnboardReset extends OnboardEvent { }