import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../data/repositories/authentication_failure_handlers.dart';
import '../data/repositories/authentication_repository.dart';
import '../models/form_inputs/confirmed_password.dart';
import '../models/form_inputs/email.dart';
import '../models/form_inputs/password.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticaionRepository) : super(const SignUpState());

  final AuthenticaionRepository _authenticaionRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
        password: password.value, value: state.confirmedPassword.value);
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(
      confirmedPassword: confirmedPassword,
    ));
  }

  Future<void> signUpFormSubmitted() async {
    if (state.email.value == '' ||
        state.password.value == '' ||
        state.confirmedPassword.value == '') {
      emit(state.copyWith(
        errorMessage: 'All fields are required.',
        status: FormzSubmissionStatus.failure,
      ));
      return;
    } else if (state.email.isNotValid ||
        state.password.isNotValid ||
        state.confirmedPassword.isNotValid) {
      return;
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticaionRepository.signUp(
          email: state.email.value, password: state.password.value);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        status: FormzSubmissionStatus.failure,
      ));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
