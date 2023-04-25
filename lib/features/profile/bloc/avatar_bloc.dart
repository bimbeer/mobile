import 'dart:io';

import 'package:bimbeer/features/profile/data/repositories/storage_repository_failure_handlers.dart';
import 'package:bimbeer/features/profile/data/repositories/storage_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../authentication/data/repositories/authentication_repository.dart';
import '../services/image_service.dart';
import 'profile_bloc.dart';

part 'avatar_event.dart';
part 'avatar_state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  AvatarBloc(
      {required StorageRepository storageRepository,
      required AuthenticaionRepository authenticaionRepository,
      required ProfileBloc profileBloc})
      : _storageRepository = storageRepository,
        _authenticationRepository = authenticaionRepository,
        _profileBloc = profileBloc,
        super(AvatarInitial()) {
    on<AvatarChangeRequested>(_onAvatarChanged);
  }

  final StorageRepository _storageRepository;
  final AuthenticaionRepository _authenticationRepository;
  final ProfileBloc _profileBloc;

  void _onAvatarChanged(
      AvatarChangeRequested event, Emitter<AvatarState> emit) async {
    try {
      File? file = await pickImage(event.imageSource);

      if (file != null) {
        String fileName = _authenticationRepository.currentUser.id;
        String? downloadUrl = await _storageRepository.addFile(
            file: file, fileName: fileName, storagePath: 'avatars');

        _profileBloc.add(ProfileModified(
            userId: _authenticationRepository.currentUser.id,
            profile: _profileBloc.state.profile.copyWith(avatar: downloadUrl)));
        emit(AvatarUpdated());
      }
    }
    on FirebaseException catch (e) {
      var failure = ImageUploadFailure.fromCode(e.code);
      emit(AvatarUpdateFailed(failure.message));
    } catch (e) {
      emit(const AvatarUpdateFailed('Something went wrong. Avatar could not be changed'));
    } 
  }
}
