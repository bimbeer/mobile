part of 'profile_card_bloc.dart';

abstract class ProfileCardEvent extends Equatable {
  const ProfileCardEvent();

  @override
  List<Object> get props => [];
}

class ProfileCardShowNextBeer extends ProfileCardEvent { }

class ProfileCardShowPreviousBeer extends ProfileCardEvent { }