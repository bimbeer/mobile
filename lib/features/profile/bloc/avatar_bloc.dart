import 'dart:async';
import 'dart:io';

import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/storage_repository_failure_handlers.dart';
import 'package:bimbeer/features/profile/data/repositories/storage_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../authentication/data/repositories/authentication_repository.dart';
import '../services/image_service.dart';

part 'avatar_event.dart';
part 'avatar_state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  AvatarBloc(
      {required StorageRepository storageRepository,
      required AuthenticaionRepository authenticaionRepository,
      required ProfileRepository profileRepository})
      : _storageRepository = storageRepository,
        _authenticationRepository = authenticaionRepository,
        _profileRepository = profileRepository,
        super(const AvatarState(status: AvatarStatus.initial)) {
    _profileSubscription = _profileRepository
        .profileStream(_authenticationRepository.currentUser.id)
        .listen((profile) {
      if (profile.avatar != state.avatar) {
        add(AvatarLoaded(profile.avatar));
      }
    });

    on<AvatarChangeRequested>(_onAvatarChangeRequested);
    on<AvatarLoaded>(_onAvatarLoaded);
  }

  final StorageRepository _storageRepository;
  final AuthenticaionRepository _authenticationRepository;
  final ProfileRepository _profileRepository;
  late final StreamSubscription _profileSubscription;

  void _onAvatarChangeRequested(
      AvatarChangeRequested event, Emitter<AvatarState> emit) async {
    try {
      File? file = await pickImage(event.imageSource);

      if (file != null) {
        String fileName = _authenticationRepository.currentUser.id;
        String? avatar = await _storageRepository.addFile(
            file: file, fileName: fileName, storagePath: 'avatars');
        final profile = _profileRepository.currentProfile;
        final updatedProfile = profile.copyWith(avatar: avatar);

        await _profileRepository.edit(
            id: _authenticationRepository.currentUser.id,
            profile: updatedProfile);
        emit(state.copyWith(status: AvatarStatus.updated, avatar: avatar));
      }
    } on FirebaseException catch (e) {
      var failure = ImageUploadFailure.fromCode(e.code);
      emit(state.copyWith(
          errorMessage: failure.message, status: AvatarStatus.updateFailed));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: 'Something went wrong. Avatar could not be changed',
          status: AvatarStatus.updateFailed));
    }
  }

  void _onAvatarLoaded(AvatarLoaded event, Emitter<AvatarState> emit) async {
    emit(state.copyWith(status: AvatarStatus.loaded, avatar: event.avatar));
  }

  @override
  Future<void> close() {
    _profileSubscription.cancel();
    return super.close();
  }
}
