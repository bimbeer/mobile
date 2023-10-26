import 'dart:io';

import 'package:bimbeer/features/profile/data/repositories/profile_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/storage_repository.dart';
import 'package:bimbeer/features/profile/data/repositories/storage_repository_failure_handlers.dart';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_service.dart';

part 'avatar_event.dart';
part 'avatar_state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  AvatarBloc(
      {required StorageRepository storageRepository,
      required ProfileRepository profileRepository})
      : _storageRepository = storageRepository,
        _profileRepository = profileRepository,
        super(const AvatarState(status: AvatarStatus.initial)) {
    on<AvatarChangeRequested>(_onAvatarChangeRequested);
    on<AvatarLoaded>(_onAvatarLoaded);
  }

  final StorageRepository _storageRepository;
  final ProfileRepository _profileRepository;

  void _onAvatarChangeRequested(
      AvatarChangeRequested event, Emitter<AvatarState> emit) async {
    try {
      File? file = await pickImage(event.imageSource);

      if (file != null) {
        String fileName = event.userId;
        String? avatar = await _storageRepository.addFile(
            file: file, fileName: fileName, storagePath: 'avatars');
        final profile = event.profile;
        final updatedProfile = profile.copyWith(avatar: avatar);

        await _profileRepository.edit(
            id: event.userId, profile: updatedProfile);
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
}
