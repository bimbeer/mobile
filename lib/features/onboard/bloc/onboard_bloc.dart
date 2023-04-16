import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboard_event.dart';
part 'onboard_state.dart';

class OnboardBloc extends Bloc<OnboardEvent, OnboardState> {
  OnboardBloc() : super(OnboardInitial()) {
    on<OnboardCreateAccountPressed>(_onCreateAccountPressed);
    on<OnboardSignInPressed>(_onSignInPressed);
  }

  void _onCreateAccountPressed(
      OnboardCreateAccountPressed event, Emitter<OnboardState> emit) {
    emit(OnboardCreateAccount());
  }

  void _onSignInPressed(
      OnboardSignInPressed event, Emitter<OnboardState> emit) {
    emit(OnboardSignIn());
  }
}